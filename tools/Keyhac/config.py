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

keyhac_path = Path(os.environ["USERPROFILE"]) / "AppData" / "Roaming" / "Keyhac"
sys.path.append(str(keyhac_path))

from extension import clipboard
from extension.fakeymacs import config as fakeymacs


def editor(path):
    # VSCode があれば使用
    editor_path = Path("C:\Program Files\Microsoft VS Code\Code.exe")
    if not editor_path.exists():
        # なければメモ帳
        editor_path = Path("notepad.exe")
    editor_path = f'\"{str(editor_path)}\"'
        
    # see https://crftwr.github.io/keyhac/doc/ja/group__pyauto.html#gaed9cb14419b28016c15906a08d92102f
    shellExecute( None, editor_path, '"%s"'% path, "" )


def configure(keymap):
    # Emacs キーバインド
    fakeymacs.configure(keymap)

    # クリップボード拡張
    clipboard.configure(keymap)
    
    # 設定ファイルを開くエディタ
    keymap.editor = editor
    # リストウィンドウを白いテーマで
    keymap.setTheme("white")

    