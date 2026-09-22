"""Derive reproducible Android, Windows and Web icons from approved source.

The WebP source remains byte-for-byte unchanged. Generated images may overwrite
Flutter starter icons, never the approved source. Requires Pillow.
"""
from __future__ import annotations

from pathlib import Path
from PIL import Image
import hashlib

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / 'assets/brand/trace-icon-selected.webp'
APP = ROOT / 'apps/trace_flutter'
EXPECTED_SHA256 = '08e7164d43c3b37f4622f8c001f24eb555c20334ea252153be93fb775232c942'
if hashlib.sha256(SOURCE.read_bytes()).hexdigest() != EXPECTED_SHA256:
    raise SystemExit('Approved source changed; refusing to regenerate.')
image = Image.open(SOURCE).convert('RGB')
assert image.width == image.height and image.width >= 1024, image.size


def save_png(path: Path, size: int, *, safe_scale: float = 1.0) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    art_size = round(size * safe_scale)
    art = image.resize((art_size, art_size), Image.Resampling.LANCZOS)
    if safe_scale < 1.0:
        # Keep the mark in Android/Web mask safe-zone without adding a real ring.
        bg = Image.new('RGB', (size, size), image.getpixel((0, 0)))
        bg.paste(art, ((size-art_size)//2, (size-art_size)//2))
        art = bg
    art.save(path, 'PNG', optimize=True)
    with Image.open(path) as check:
        assert check.size == (size, size)
    print(path.relative_to(ROOT),size)

web=APP / 'web'
save_png(web / 'favicon.png',64)
for size in (192,512):
    save_png(web / 'icons' / f'Icon-{size}.png',size)
    save_png(web / 'icons' / f'Icon-maskable-{size}.png',size,safe_scale=0.92)

res=APP / 'android/app/src/main/res'
for density,size in (('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)):
    save_png(res / f'mipmap-{density}' / 'ic_launcher.png',size)
# Adaptive foreground uses the full artwork within a central mask-safe area;
# the platform mask clips the outer background, not the symbol.
save_png(res/'drawable-nodpi'/'ic_launcher_foreground.png',432,safe_scale=0.72)

ico=APP/'windows/runner/resources/app_icon.ico'
windows=image.resize((256,256),Image.Resampling.LANCZOS)
windows.save(ico,format='ICO',sizes=[(s,s) for s in (16,24,32,48,64,128,256)])
with Image.open(ico) as check:
    assert check.format=='ICO' and check.size==(256,256)
print(ico.relative_to(ROOT),'ICO 16..256')
