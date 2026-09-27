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
                    try:
                        if evaluate("!!document.querySelector('flt-glass-pane')"):
                            break
                    except RuntimeError as error:
                        # Chrome can expose CDP before committing navigation.
                        if "Cannot find default execution context" not in str(error):
                            raise
                    time.sleep(.2)
                else:
                    raise RuntimeError("Flutter did not mount")
                time.sleep(1)
                viewport = evaluate("({w: innerWidth, h: innerHeight})")
                new_x = int(viewport["w"] * 0.14)
                new_y = int(viewport["h"] * 0.51)
                # WASM DB opening can delay the first library-frame button.
                # Retry bounded click until its dialog field exists.
                for _ in range(40):
                    for kind in ("mousePressed", "mouseReleased"):
                        call("Input.dispatchMouseEvent", {
                            "type": kind, "x": new_x, "y": new_y, "button": "left", "clickCount": 1,
                        })
                    time.sleep(.5)
                    if evaluate("!!document.querySelector('.flt-text-editing')"):
                        break
                else:
                    raise RuntimeError("New collection dialog did not open")
                call("Input.insertText", {"text": TITLE})
                for kind in ("keyDown", "keyUp"):
                    call("Input.dispatchKeyEvent", {
                        "type": kind, "key": "Enter", "code": "Enter", "windowsVirtualKeyCode": 13,
                    })
                time.sleep(2)
                probe = "new Promise((resolve,reject)=>{let q=indexedDB.open('trace_local_v1');q.onerror=()=>reject(q.error);q.onsuccess=async()=>{let d=q.result;let b=await new Promise((yes,no)=>{let r=d.transaction('blocks').objectStore('blocks').getAll();r.onerror=()=>no(r.error);r.onsuccess=()=>yes(r.result)});let names=[...d.objectStoreNames];let mode=d.objectStoreNames.contains('__drift_meta')?'drift-meta':'raw';d.close();resolve(JSON.stringify({hit: b.some(v=>new TextDecoder().decode(new Uint8Array(v)).includes('Trace browser persistence')), names: names, storeMode: mode}))}})"
                probe_raw = evaluate(probe)
                if not probe_raw or '"hit":true' not in probe_raw:
                    raise RuntimeError("Exact title not persisted before reload")
                storage_sig = probe_raw
                if os.environ.get('TRACE_SMOKE_SCREENSHOT'):
                    import base64
                    Path(os.environ['TRACE_SMOKE_SCREENSHOT']).write_bytes(base64.b64decode(call('Page.captureScreenshot', {'format':'png'})['data']))
                call("Page.reload", {"ignoreCache": True})
                time.sleep(3)
                probe_raw_after = evaluate(probe)
                if not probe_raw_after or '"hit":true' not in probe_raw_after:
                    raise RuntimeError("Exact title lost after reload")
                print(f"STORAGE: {storage_sig} -> {probe_raw_after}")
                if os.environ.get('TRACE_SMOKE_IMPORT') or os.environ.get('TRACE_SMOKE_PDF'):
                    pdf_mode = bool(os.environ.get('TRACE_SMOKE_PDF'))
                    source = Path(__file__).resolve().parent.parent / 'apps/trace_flutter/test/fixtures/dummy.pdf' if pdf_mode else Path(profile) / 'chapter.md'
                    if not pdf_mode:
                        source.write_text('# First chapter\nPersian source.\n', encoding='utf-8')
                    for kind in ("mousePressed", "mouseReleased"):
                        call("Input.dispatchMouseEvent", {"type": kind, "x": 110, "y": 138, "button": "left", "clickCount": 1})
                    time.sleep(1)
                    if os.environ.get('TRACE_SMOKE_SCREENSHOT'):
                        import base64
                        Path(os.environ['TRACE_SMOKE_SCREENSHOT']).write_bytes(base64.b64decode(call('Page.captureScreenshot', {'format':'png'})['data']))
                    for kind in ("mousePressed", "mouseReleased"):
                        call("Input.dispatchMouseEvent", {"type": kind, "x": 590 if pdf_mode else 438, "y": 93, "button": "left", "clickCount": 1})
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
                    expected = '%PDF-1.4' if pdf_mode else 'First chapter'
                    source_probe = probe.replace('Trace browser persistence', expected)
                    if not evaluate(source_probe):
                        raise RuntimeError(f'Picked {source.suffix} bytes not stored in SQLite')
                    call('Page.reload', {'ignoreCache': True})
                    time.sleep(3)
                    if not evaluate(source_probe):
                        raise RuntimeError(f'Picked {source.suffix} original lost on reload')
                    print(f'PASS: native Chrome chooser imported {source.suffix} and original survived reload')
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
