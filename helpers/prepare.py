import shutil
import os
import zipfile

from subprocess import call

def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)

touch('packages/google/__init__.py')

call(["C:\Python27\Lib\site-packages\PyQt4\pyrcc4.exe", "icons.qrc", "-o" ,  "gui/qt/icons_rc.py"])

with zipfile.ZipFile('artifacts/dist/trezor-0.6.7.win32.zip', "r") as z:
    z.extractall("artifacts")

shutil.copy2('artifacts/Python27/Scripts/trezorctl', 'packages/trezorctl.py')

shutil.copytree('packages/requests', 'requests')