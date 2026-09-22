"""Verify approved Trace icon lineage and native icon surfaces."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import hashlib
import json

root=Path(__file__).resolve().parent.parent
app=root/'apps/trace_flutter'
source=root/'assets/brand/trace-icon-selected.webp'
assert hashlib.sha256(source.read_bytes()).hexdigest()=='08e7164d43c3b37f4622f8c001f24eb555c20334ea252153be93fb775232c942'
paths={
 'Android 48':(app/'android/app/src/main/res/mipmap-mdpi/ic_launcher.png',48),
 'Android 192':(app/'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',192),
 'Web 192':(app/'web/icons/Icon-192.png',192),
 'Web maskable':(app/'web/icons/Icon-maskable-192.png',192),
 'Favicon 64':(app/'web/favicon.png',64),
}
for label,(path,size) in paths.items():
 with Image.open(path) as img: assert img.size==(size,size), (label,img.size)
ico=app/'windows/runner/resources/app_icon.ico'
with Image.open(ico) as img:
 assert img.format=='ICO' and (16,16) in img.ico.sizes() and (256,256) in img.ico.sizes(),img.ico.sizes()
 sizes=sorted(img.ico.sizes())
manifest=json.loads((app/'web/manifest.json').read_text(encoding='utf-8'))
assert manifest['name']==manifest['short_name']=='Trace'

font=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',22)
board=Image.new('RGB',(1500,330),'#E5E7E6'); draw=ImageDraw.Draw(board)
original=Image.open(source).convert('RGB').resize((210,210),Image.Resampling.LANCZOS)
board.paste(original,(30,40)); draw.text((30,270),'Approved source',fill='#162129',font=font)
for i,(label,(path,size)) in enumerate(paths.items()):
 tile=Image.open(path).convert('RGB')
 x=285+i*235
 if label=='Web maskable':
  tile=tile.resize((190,190),Image.Resampling.LANCZOS)
  mask=Image.new('L',(190,190),0); ImageDraw.Draw(mask).ellipse((0,0,189,189),fill=255)
  base=Image.new('RGB',(190,190),'#121214'); base.paste(tile,(0,0),mask); tile=base
 else: tile=tile.resize((190,190),Image.Resampling.NEAREST if size<=64 else Image.Resampling.LANCZOS)
 board.paste(tile,(x,50)); draw.text((x,270),label,fill='#162129',font=font)
proof=root/'docs/design/previews/icons/trace-selected-platform-proof.png'
board.save(proof)
print('PASS source sha256 / android / web / windows',sizes,proof)
