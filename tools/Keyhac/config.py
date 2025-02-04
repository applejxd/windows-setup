"""
Keyhac 設定ファイル
See https://crftwr.github.io/keyhac/doc/ja/#id8
"""
import datetime
import os
import sys
from pathlib import Path

import pyauto
from keyhac import *

keyhac_path = Path(os.environ['USERPROFILE']) / "AppData" / "Roaming" / "Keyhac"
sys.path.append(str(keyhac_path))

from extension import clipboard
from extension.fakeymacs import config as fakeymacs


def editor(path):
    shellExecute( None, None, "notepad.exe", '"%s"'% path, "" )

def configure(keymap):
    # 設定ファイルを開くエディタ
    keymap.editor = editor
    
    # リストウィンドウを白いテーマで
    keymap.setTheme("white")

    # Emacs キーバインド
    fakeymacs.configure(keymap)

    # クリップボード拡張
    clipboard.configure(keymap)
