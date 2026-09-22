"""Capture Stage-5 HTML mocks in isolated headless Chrome and report DOM geometry.

Design preview QA only. Not a Flutter or product runtime test.
"""
from __future__ import annotations

import base64
import json
from pathlib import Path
import subprocess
import tempfile
import time
from urllib.request import Request, urlopen

from websockets.sync.client import connect

ROOT = Path(__file__).resolve().parents[1]
PREVIEWS = ROOT / "docs" / "design" / "previews"
CHROME = Path(r"C:\Program Files\Google\Chrome\Application\chrome.exe")
SIZES = {"desktop": (1440, 900), "phone": (375, 844)}
NAMES = ("evidence-atelier", "signal-console")


def main() -> None:
    if not CHROME.is_file():
        raise SystemExit("Chrome missing; no screenshot claims")
    with tempfile.TemporaryDirectory(prefix="trace-mock-chrome-") as profile:
        proc = subprocess.Popen(
            [str(CHROME), "--headless=new", "--no-first-run", "--no-default-browser-check",
             "--disable-gpu", "--disable-extensions", "--remote-allow-origins=*",
             "--remote-debugging-port=0", f"--user-data-dir={profile}", "about:blank"],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
        )
        try:
            portfile = Path(profile) / "DevToolsActivePort"
            for _ in range(60):
                if portfile.exists():
                    break
                if proc.poll() is not None:
                    raise RuntimeError(f"Chrome exited early: {proc.returncode}")
                time.sleep(.1)
            else:
                raise RuntimeError("Chrome CDP endpoint not ready")
            port = int(portfile.read_text().splitlines()[0])
            for name in NAMES:
                url = (PREVIEWS / (name + ".html")).as_uri()
                request = Request(f"http://127.0.0.1:{port}/json/new?{url}", method="PUT")
                with urlopen(request, timeout=5) as response:
                    tab = json.load(response)
                with connect(tab["webSocketDebuggerUrl"], origin="http://localhost") as ws:
                    sequence = 0

                    def call(method: str, params: dict | None = None) -> dict:
                        nonlocal sequence
                        sequence += 1
                        wanted = sequence
                        ws.send(json.dumps({"id": wanted, "method": method, "params": params or {}}))
                        while True:
                            reply = json.loads(ws.recv(timeout=15))
                            if reply.get("id") == wanted:
                                if "error" in reply:
                                    raise RuntimeError(f"{method}: {reply['error']}")
                                return reply["result"]

                    call("Page.enable")
                    call("Runtime.enable")
                    for _ in range(50):
                        state = call("Runtime.evaluate", {"expression": "document.readyState", "returnByValue": True})
                        if state["result"]["value"] == "complete":
                            break
                        time.sleep(.1)
                    else:
                        raise RuntimeError(f"{name} never loaded")
                    font_probe = call("Runtime.evaluate", {"expression": "Promise.all([document.fonts.load('16px Inter'),document.fonts.load('16px Vazirmatn')]).then(()=>({inter:document.fonts.check('16px Inter'),vazirmatn:document.fonts.check('16px Vazirmatn'),badDigits:/[\\u0660-\\u0669\\u06f0-\\u06f9]/.test(document.body.textContent)}))", "awaitPromise": True, "returnByValue": True})["result"]["value"]
                    if not (font_probe["inter"] and font_probe["vazirmatn"]) or font_probe["badDigits"]:
                        raise RuntimeError(f"Typography or ASCII numeral contract failed: {name}: {font_probe}")
                    print(json.dumps({"mock": name, "fonts": font_probe}))
                    for mode, (width, height) in SIZES.items():
                        call("Emulation.setDeviceMetricsOverride", {"width": width, "height": height, "deviceScaleFactor": 1, "mobile": False})
                        time.sleep(.2)
                        expression = """(() => {
                            const q=s=>document.querySelector(s);
                            const b=s=>{const e=q(s); if(!e) return null; const r=e.getBoundingClientRect();return {x:r.x,y:r.y,w:r.width,h:r.height}};
                            const visible=s=>{let e=q(s);return e&&getComputedStyle(e).display!=='none'};
                            return {title:document.title, viewport:[innerWidth,innerHeight],scroll:[document.documentElement.scrollWidth,document.documentElement.clientWidth],
                              header:b('header'),stage:b('main'),lesson:b('article'),tree:visible('.tree'),
                              iconLoaded:q('header img')?.naturalWidth>0, persianDirection:getComputedStyle(q('.fa,.persian')).direction,
                              firstText:q('.fa,.persian').textContent.substring(0,42),
                              buttons:[...document.querySelectorAll('button')].filter(e=>getComputedStyle(e).display!=='none').map(e=>({label:e.textContent.trim().substring(0,32),w:e.getBoundingClientRect().width,h:e.getBoundingClientRect().height}))};
                        })()"""
                        result = call("Runtime.evaluate", {"expression": expression, "returnByValue": True})["result"]
                        data = result["value"]
                        if not data["iconLoaded"] or data["persianDirection"] != "rtl":
                            raise RuntimeError(f"Mock asset or RTL failed: {name}: {data}")
                        print(json.dumps({"mock": name, "mode": mode, "geometry": data}, ensure_ascii=False))
                        if data["scroll"][0] > data["scroll"][1] + 2:
                            diagnosis = call("Runtime.evaluate", {"expression": "[...document.querySelectorAll('*')].map(e=>({tag:e.tagName,cls:e.className,r:e.getBoundingClientRect()})).filter(o=>o.r.width&&o.r.right>document.documentElement.clientWidth+1).slice(0,12).map(o=>({tag:o.tag,cls:o.cls,right:o.r.right,width:o.r.width}))", "returnByValue": True})["result"]["value"]
                            raise RuntimeError(f"Horizontal overflow: {name}/{mode}: {data['scroll']}; offenders={diagnosis}")
                        output = PREVIEWS / f"{name}-{mode}.png"
                        png = call("Page.captureScreenshot", {"format": "png", "captureBeyondViewport": False})["data"]
                        output.write_bytes(base64.b64decode(png))
                        print(json.dumps({"mock": name, "mode": mode, "path": str(output), "size": output.stat().st_size, "geometry": data}, ensure_ascii=False))
                    for mode, (width, height) in {"narrow": (320, 700), "tablet": (768, 1024)}.items():
                        call("Emulation.setDeviceMetricsOverride", {"width": width, "height": height, "deviceScaleFactor": 1, "mobile": False})
                        probe = call("Runtime.evaluate", {"expression": "({w:document.documentElement.scrollWidth,c:document.documentElement.clientWidth,tree:getComputedStyle(document.querySelector('.tree')).display})", "returnByValue": True})["result"]["value"]
                        if probe["w"] > probe["c"] + 2:
                            raise RuntimeError(f"{name}/{mode} overflow: {probe}")
                        print(json.dumps({"mock": name, "mode": mode, "layout": probe}))
                    call("Emulation.setDeviceMetricsOverride", {"width": 375, "height": 844, "deviceScaleFactor": 1, "mobile": False})
                    action = call("Runtime.evaluate", {"expression": "(() => {const menu=document.querySelector('header .mobile');menu.click();const open=document.querySelector('.tree').classList.contains('open');menu.click();const closed=!document.querySelector('.tree').classList.contains('open');return {open,closed}})()", "returnByValue": True})["result"]["value"]
                    if not (action["open"] and action["closed"]):
                        raise RuntimeError(f"{name} mobile Worktree inaccessible: {action}")
                    print(json.dumps({"mock": name, "mobileWorktree": action}))
                    call("Emulation.clearDeviceMetricsOverride")
                with urlopen(Request(f"http://127.0.0.1:{port}/json/close/{tab['id']}", method="GET"), timeout=5):
                    pass
            print("PASS: 4 mock screenshots; icon, RTL, and horizontal overflow checks")

        finally:
            proc.terminate()
            try:
                proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait(timeout=5)


if __name__ == "__main__":
    main()
