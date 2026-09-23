"""Exercise real Flutter Web collection creation and reload in fresh Chrome profile.

Requires: `python tool/serve_web_with_coop.py` on port 8766; websockets package.
Checks both exact saved SQLite page content in IndexedDB and persistence on reload.
"""
from __future__ import annotations
import json
import os
import subprocess
import tempfile
import time
from pathlib import Path
from urllib.request import Request, urlopen
from websockets.sync.client import connect

CHROME = Path(os.environ.get("TRACE_CHROME", r"C:\Program Files\Google\Chrome\Application\chrome.exe"))
URL = os.environ.get("TRACE_WEB_URL", "http://127.0.0.1:8766/")
TITLE = "Trace browser persistence"


def run() -> None:
    with tempfile.TemporaryDirectory(prefix="trace-web-smoke-") as profile:
        proc = subprocess.Popen(
            [str(CHROME), "--headless=new", "--no-first-run", "--no-default-browser-check",
             "--disable-gpu", "--disable-extensions", "--remote-allow-origins=*",
             "--remote-debugging-port=0", f"--user-data-dir={profile}", "about:blank"],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
        )
        try:
            portfile = Path(profile) / "DevToolsActivePort"
            for _ in range(100):
                if portfile.exists():
                    break
                if proc.poll() is not None:
                    raise RuntimeError(f"Chrome exited: {proc.returncode}")
                time.sleep(.1)
            for _ in range(50):
                try:
                    port = int(portfile.read_text().splitlines()[0])
                    break
                except (PermissionError, IndexError, FileNotFoundError):
                    time.sleep(.1)
            else:
                raise RuntimeError('Chrome CDP port unavailable')
            with urlopen(Request(f"http://127.0.0.1:{port}/json/new?{URL}", method="PUT"), timeout=5) as response:
                tab = json.load(response)
            with connect(tab["webSocketDebuggerUrl"], origin="http://localhost") as ws:
                serial = 0
                chooser_events = []

                def call(method, params=None):
                    nonlocal serial
                    serial += 1
                    current = serial
                    ws.send(json.dumps({"id": current, "method": method, "params": params or {}}))
                    while True:
                        result = json.loads(ws.recv(timeout=25))
                        if result.get('method') == 'Page.fileChooserOpened':
                            chooser_events.append(result['params'])
                        if result.get("id") == current:
                            if "error" in result:
                                raise RuntimeError(f"{method}: {result['error']}")
                            return result["result"]

                def evaluate(expression):
                    result = call("Runtime.evaluate", {
                        "expression": expression, "returnByValue": True, "awaitPromise": True,
                    })
                    if "exceptionDetails" in result:
                        raise RuntimeError(str(result["exceptionDetails"]))
                    return result["result"].get("value")

                call("Page.enable")
                call("Page.setInterceptFileChooserDialog", {"enabled": True})
                call("Runtime.enable")
                for _ in range(200):
                    if evaluate("!!document.querySelector('flt-glass-pane')"):
                        break
                    time.sleep(.2)
                else:
                    raise RuntimeError("Flutter did not mount")
                time.sleep(1)
                for kind in ("mousePressed", "mouseReleased"):
                    call("Input.dispatchMouseEvent", {
                        "type": kind, "x": 670, "y": 28, "button": "left", "clickCount": 1,
                    })
                time.sleep(.4)
                if not evaluate("!!document.querySelector('.flt-text-editing')"):
                    raise RuntimeError("New collection dialog did not open")
                call("Input.insertText", {"text": TITLE})
                for kind in ("keyDown", "keyUp"):
                    call("Input.dispatchKeyEvent", {
                        "type": kind, "key": "Enter", "code": "Enter", "windowsVirtualKeyCode": 13,
                    })
                time.sleep(2)
                probe = "new Promise((resolve,reject)=>{let q=indexedDB.open('trace_local_v1');q.onerror=()=>reject(q.error);q.onsuccess=async()=>{let d=q.result;let b=await new Promise((yes,no)=>{let r=d.transaction('blocks').objectStore('blocks').getAll();r.onerror=()=>no(r.error);r.onsuccess=()=>yes(r.result)});d.close();resolve(b.some(v=>new TextDecoder().decode(new Uint8Array(v)).includes('Trace browser persistence')))}})"
                if not evaluate(probe):
                    raise RuntimeError("Exact title not persisted before reload")
                if os.environ.get('TRACE_SMOKE_SCREENSHOT'):
                    import base64
                    Path(os.environ['TRACE_SMOKE_SCREENSHOT']).write_bytes(base64.b64decode(call('Page.captureScreenshot', {'format':'png'})['data']))
                call("Page.reload", {"ignoreCache": True})
                time.sleep(3)
                if not evaluate(probe):
                    raise RuntimeError("Exact title lost after reload")
                if os.environ.get('TRACE_SMOKE_IMPORT'):
                    source = Path(profile) / 'chapter.md'
                    source.write_text('# First chapter\nPersian source.\n', encoding='utf-8')
                    for kind in ("mousePressed", "mouseReleased"):
                        call("Input.dispatchMouseEvent", {"type": kind, "x": 110, "y": 138, "button": "left", "clickCount": 1})
                    time.sleep(1)
                    if os.environ.get('TRACE_SMOKE_SCREENSHOT'):
                        import base64
                        Path(os.environ['TRACE_SMOKE_SCREENSHOT']).write_bytes(base64.b64decode(call('Page.captureScreenshot', {'format':'png'})['data']))
                    for kind in ("mousePressed", "mouseReleased"):
                        call("Input.dispatchMouseEvent", {"type": kind, "x": 515, "y": 93, "button": "left", "clickCount": 1})
                    call('Runtime.evaluate', {'expression': 'document.querySelectorAll("input[type=file]").length'})
                    if not chooser_events:
                        for _ in range(20):
                            event = json.loads(ws.recv(timeout=2))
                            if event.get('method') == 'Page.fileChooserOpened':
                                chooser_events.append(event['params'])
                                break
                    if not chooser_events:
                        raise RuntimeError('Real file picker did not open')
                    call('DOM.setFileInputFiles', {'files': [str(source)], 'backendNodeId': chooser_events[-1]['backendNodeId']})
                    time.sleep(2)
                    source_probe = probe.replace('Trace browser persistence', 'First chapter')
                    if not evaluate(source_probe):
                        raise RuntimeError('Picked Markdown bytes not stored in SQLite')
                    call('Page.reload', {'ignoreCache': True})
                    time.sleep(3)
                    if not evaluate(source_probe):
                        raise RuntimeError('Picked Markdown original lost on reload')
                    print('PASS: native Chrome chooser imported Markdown and original survived reload')
                print("PASS: exact collection persisted in IndexedDB across Chrome reload")
        finally:
            proc.terminate()
            try:
                proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait(timeout=5)


if __name__ == "__main__":
    run()
