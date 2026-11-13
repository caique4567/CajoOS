import math
import os
import sys

try:
    import pycdlib
except ImportError:
    raise SystemExit('Missing pycdlib. Install it with: python -m pip install pycdlib')

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
OUT = os.path.join(ROOT, 'out')
BOOT_IMAGE = os.path.join(OUT, 'os-eltorito.img')
ISO_PATH = os.path.join(OUT, 'CajoOS.iso')

if not os.path.isfile(BOOT_IMAGE):
    raise SystemExit('Boot image not found. Run python .\\build.py first.')

boot_size = os.path.getsize(BOOT_IMAGE)
if boot_size % 512:
    raise SystemExit('El Torito boot image must be a multiple of 512 bytes.')

iso = pycdlib.PyCdlib()
iso.new(interchange_level=3, vol_ident='CAJOOS', joliet=3)
iso.add_file(BOOT_IMAGE, iso_path='/CAJOOS.IMG;1', joliet_path='/CajoOS.img')
iso.add_eltorito(
    '/CAJOOS.IMG;1',
    boot_load_size=math.ceil(boot_size / 512),
    media_name='noemul',
)
try:
    iso.write(ISO_PATH)
finally:
    iso.close()

print(f'Created {ISO_PATH} ({os.path.getsize(ISO_PATH)} bytes)')
