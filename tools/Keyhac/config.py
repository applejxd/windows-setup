import sys
import os
import datetime

import pyauto
from keyhac import *

sys.path.append(r"{home}\AppData\Roaming\Keyhac".format(home=os.environ['USERPROFILE']))
from extension import clipboard
from extension.fakeymacs import config as fakeymacs


def configure(keymap):
    # 設定ファイルを開くエディタ
    # keymap.editor = r"C:\tools\Code.exe"
    # リストウィンドウを白いテーマで
    keymap.setTheme("white")

    # Emacs キーバインド
    fakeymacs.configure(keymap)

    # クリップボード拡張
    clipboard.configure(keymap)
