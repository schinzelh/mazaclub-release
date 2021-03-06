import shutil
import os
import zipfile
import tarfile

from sys import platform as _platform
from subprocess import call

def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)

touch('packages/google/__init__.py')


if _platform == "linux" or _platform == "linux2":
    # linux
    call(["/usr/local/bin/pyrcc4", "icons.qrc", "-o" ,  "gui/qt/icons_rc.py"])
elif _platform == "darwin":
    # MAC OS X
    call(["/usr/local/bin/pyrcc4", "icons.qrc", "-o" ,  "gui/qt/icons_rc.py"])
    
    tar = tarfile.open("artifacts/dist/trezor-0.6.7.macosx-10.9-x86_64.tar.gz", "r:gz")
    tar.extractall("artifacts")
    
    shutil.copy2('artifacts/bin/trezorctl', 'packages/trezorctl.py')


elif _platform == "win32":
    # Windows
    call(["C:\Python27\Lib\site-packages\PyQt4\pyrcc4.exe", "icons.qrc", "-o" ,  "gui/qt/icons_rc.py"])
    
    with zipfile.ZipFile('artifacts/dist/trezor-0.7.0.win32.zip', "r") as z:
        z.extractall("artifacts")
    shutil.copy2('artifacts/Python27/Scripts/trezorctl', 'packages/trezorctl.py')

    with zipfile.ZipFile('artifacts/dist/keepkey-0.7.2.win32.zip', "r") as z:
        z.extractall("artifacts")
    shutil.copy2('artifacts/Python27/Scripts/keepkeyctl', 'packages/keepkeyctl.py')


shutil.copytree('packages/requests', 'requests')
