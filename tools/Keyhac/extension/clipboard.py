#########################################
# クリップボード検索
# http://tinyurl.com/y87fxwvx
#########################################

import sys
import os
import datetime
import re
from time import sleep
from collections import Counter

import pyauto
from keyhac import *


def configure(keymap):
    # 全体で有効なキーマップのオブジェクト
    keymap_global = keymap.defineWindowKeymap()

    # 検索に影響する記号類を半角プラスに変換する関数
    def mark2plus(str):
        ptn_list = []
        ptn_list.append("[（）「」【】『』［］〈〉《》〔〕｛｝”]")  # 全角括弧
        ptn_list.append("[・，、。．：；―～─]")  # 全角句読点
        ptn_list.append("[!-/:-@[-`{-~]")  # 半角記号
        ptn_list.append("\s")   # 空白文字
        ptn = "|".join(ptn_list)
        s = re.compile(ptn).sub("+", str)
        return s

    # 検索に影響する記号類を半角プラスに変換する関数
    def replace_space(str):
        # re モジュールを使った正規表現パターンオブジェクトでの置換
        s = re.compile("\s").sub("%20", str)
        return s

    def search_ja(URLstr):
        # クリップボードクリア
        setClipboardText("")
        # コピー実行
        keymap.InputKeyCommand("C-C")()
        sleep(0.1)
        # クリップボード取得
        str = getClipboardText()
        # 例外処理
        if not str:
            keymap.popBalloon("", "failed to copy...", 1500)
            return None
        # 検索サイト + 検索内容
        goURL = URLstr + mark2plus(str)
        # 検索実行
        keymap.ShellExecuteCommand(None, goURL, "", "")()

    def search_en(URLstr):
        # クリップボードクリア
        setClipboardText("")
        # コピー実行
        keymap.InputKeyCommand("C-C")()
        sleep(0.1)
        # クリップボード取得
        str = getClipboardText()
        # 例外処理
        if not str:
            keymap.popBalloon("", "failed to copy...", 1500)
            return None
        # 検索サイト + 検索内容
        goURL = URLstr + replace_space(str)
        # 検索実行
        keymap.ShellExecuteCommand(None, goURL, "", "")()

    # 無変換キー(U0)+S(earch)に続けて文字を入力して検索
    keymap.defineModifier("(29)", "User0")
    keymap_global["U0-S"] = keymap.defineMultiStrokeKeymap("U0-S")

    def sch_google():
        search_ja(r"http://www.google.co.jp/search?q=")
    keymap_global["U0-S"]["G"] = sch_google

    def sch_deepl():
        search_en(r"https://www.deepl.com/ja/translator#en/ja/")
    keymap_global["U0-S"]["D"] = sch_deepl
