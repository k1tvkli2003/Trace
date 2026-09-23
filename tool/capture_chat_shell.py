"""Capture actual Flutter Web screenshots at desktop and mobile widths via isolated Chrome."""
import base64
import json
import os
import subprocess
import tempfile
import time
from pathlib import Path
from urllib.request import Request, urlopen
from websockets.sync.client import connect

CHROME = Path(r'C:\Program Files\Google\Chrome\Application\chrome.exe')
URL = os.environ.get('TRACE_WEB_URL', 'http://127.0.0.1:8770/')
OUT = Path(__file__).resolve().parents[1] / 'docs' / 'design' / 'runtime'
OUT.mkdir(parents=True, exist_ok=True)


def capture(width, height, name, selected=False, teaching=False, rail=False):
    with tempfile.TemporaryDirectory(prefix='trace-chat-capture-') as profile:
        process = subprocess.Popen([
            str(CHROME), '--headless=new', '--no-first-run', '--disable-gpu',
            '--no-default-browser-check', '--remote-allow-origins=*',
            '--remote-debugging-port=0', f'--user-data-dir={profile}', 'about:blank',
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        try:
            marker = Path(profile) / 'DevToolsActivePort'
            port = None
            for _ in range(100):
                try:
                    if marker.is_file():
                        port = int(marker.read_text().splitlines()[0])
                        break
                except (PermissionError, ValueError, IndexError):
                    # Chrome may still be replacing its startup marker.
                    pass
                if process.poll() is not None:
                    raise RuntimeError('Chrome exited before opening DevTools')
                time.sleep(.1)
            if port is None:
                raise RuntimeError('Chrome DevTools marker was not readable')

            with urlopen(Request(f'http://127.0.0.1:{port}/json/new?{URL}', method='PUT')) as response:
                tab = json.load(response)
            with connect(tab['webSocketDebuggerUrl'], origin='http://localhost') as ws:
                sequence = 0

                def call(method, params=None):
                    nonlocal sequence
                    sequence += 1
                    ws.send(json.dumps({'id': sequence, 'method': method, 'params': params or {}}))
                    while True:
                        result = json.loads(ws.recv(timeout=25))
                        if result.get('id') == sequence:
                            if 'error' in result:
                                raise RuntimeError(str(result['error']))
                            return result['result']

                call('Page.enable')
                call('Runtime.enable')
                call('Emulation.setDeviceMetricsOverride', {
                    'width': width, 'height': height, 'deviceScaleFactor': 1,
                    'mobile': width < 700,
                })
                call('Page.reload', {'ignoreCache': True})
                for _ in range(80):
                    response = call('Runtime.evaluate', {
                        'expression': "!!document.querySelector('flutter-view')",
                        'returnByValue': True,
                    })
                    if response['result'].get('value'):
                        break
                    time.sleep(.2)
                else:
                    raise RuntimeError('Flutter view did not mount')
                time.sleep(2)
                if selected:
                    def click(x, y):
                        for kind in ('mousePressed', 'mouseReleased'):
                            call('Input.dispatchMouseEvent', {
                                'type': kind, 'x': x, 'y': y,
                                'button': 'left', 'clickCount': 1,
                            })

                    click(116, 245)
                    time.sleep(.5)
                    call('Input.insertText', {'text': 'Biology Atlas'})
                    call('Input.dispatchKeyEvent', {
                        'type': 'keyDown', 'key': 'Enter', 'code': 'Enter',
                        'windowsVirtualKeyCode': 13,
                    })
                    call('Input.dispatchKeyEvent', {
                        'type': 'keyUp', 'key': 'Enter', 'code': 'Enter',
                        'windowsVirtualKeyCode': 13,
                    })
                    time.sleep(2)
                    value = call('Runtime.evaluate', {
                        'expression': '''new Promise((resolve,reject)=>{let q=indexedDB.open('trace_local_v1');q.onerror=()=>reject(q.error);q.onsuccess=async()=>{let d=q.result;let b=await new Promise((yes,no)=>{let r=d.transaction('blocks').objectStore('blocks').getAll();r.onerror=()=>no(r.error);r.onsuccess=()=>yes(r.result)});d.close();resolve(b.some(v=>new TextDecoder().decode(new Uint8Array(v)).includes('Biology Atlas')))}})''',
                        'returnByValue': True, 'awaitPromise': True,
                    })
                    if value['result'].get('value') is not True:
                        raise RuntimeError('Selected collection was not persisted in Chrome')
                    if teaching:
                        if width != 1440 or height != 900:
                            raise ValueError('Teaching screenshot coordinate requires 1440x900')
                        click(650, 545)
                        time.sleep(1)
                    if rail:
                        if width != 1440 or height != 900:
                            raise ValueError('Source rail screenshot coordinate requires 1440x900')
                        click(1347, 31)
                        time.sleep(1)
                image = call('Page.captureScreenshot', {'format': 'png', 'captureBeyondViewport': False})
                target = OUT / name
                target.write_bytes(base64.b64decode(image['data']))
                print(f'{target} ({width}x{height})')
        finally:
            process.terminate()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()


if __name__ == '__main__':
    capture(1440, 900, 'chat-shell-desktop.png')
    capture(390, 844, 'chat-shell-mobile.png')
    capture(1440, 900, 'chat-shell-selected.png', selected=True)
