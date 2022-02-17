# cf. https://keypirinha.com/api/plugin.html
from typing import List

import keypirinha as kp
import keypirinha_util as kpu

from collections import namedtuple
import datetime
import os
import subprocess


class _BasePlugin(kp.Plugin):
    """
    リポジトリを開くクラスの抽象基底クラス
    """
    ITEMCAT_RESULT = kp.ItemCategory.USER_BASE + 1

    # 処理結果を保存するリスト
    root_path = ""
    repos = []

    def __init__(self):
        super().__init__()

    def on_start(self):
        """初期化"""
        self.repos = []
        # ItemCategory に CatalogAction のリストを割り当て
        self.set_actions(self.ITEMCAT_RESULT, [
            # CatalogAction オブジェクトの生成
            self.create_action(
                name="copy",
                label="Copy",
                short_desc="Copy the name of the answer")
        ])

    def on_catalog(self):
        """
        カタログ生成.
        Keypirinha で起動するためのトリガー・説明など.
        """
        pass

    def on_suggest(self, user_input, items_chain):
        """検索処理

        Args:
            user_input : 入力内容
            items_chain : 選択したアイテム
        """
        # カテゴリが異なる場合
        if not items_chain or items_chain[-1].category() != kp.ItemCategory.KEYWORD:
            return

        # サジェスト作成
        suggestions = []

        # 降順ループ
        for idx in range(0, len(self.repos)):
            # サジェスト追加
            suggestions.append(
                # CatalogItem オブジェクト生成
                self.create_item(
                    category=self.ITEMCAT_RESULT,
                    label=self.repos[idx],
                    short_desc=self.repos[idx],
                    target=self.repos[idx],
                    args_hint=kp.ItemArgsHint.FORBIDDEN,
                    hit_hint=kp.ItemHitHint.IGNORE)
            )

        # サジェスト表示
        self.set_suggestions(
            suggestions,
            # マッチング方式
            kp.Match.FUZZY,
            # ソートのルール
            kp.Sort.NONE
        )

    def on_execute(self, item, action):
        """ 実行処理

        Args:
            item (CatalogItem): on_suggest で選択した項目
            action (CatalogAction): [description]
        """
        command = f'{self.open_command} {self.root_path}/{item.target()}'
        subprocess.run(command, shell=True, check=True)


class GhqWindows(_BasePlugin):
    def __init__(self):
        super().__init__()
        self.open_command = "code"

    def on_start(self):
        """初期化"""
        super().on_start()
        self.root_path = subprocess.run(
            'powershell -ExecutionPolicy Bypass ghq root',
            shell=True, stdout=subprocess.PIPE, check=True
        ).stdout.decode('utf-8').strip()

    def on_catalog(self):
        """
        カタログ生成.
        Keypirinha で起動するためのトリガー・説明など.
        """
        # CatalogItem のリストで catalog の変更
        self.set_catalog([
            # CatalogItem 生成
            self.create_item(
                # 入力のカテゴリ
                category=kp.ItemCategory.KEYWORD,
                # 表示名
                label="repos (ghq for Windows)",
                # 説明
                short_desc="Open repositories",
                # 起動キーワード
                target="repos_win",
                # 引数を要求する
                args_hint=kp.ItemArgsHint.REQUIRED,
                # 重複なしで履歴を保存
                hit_hint=kp.ItemHitHint.NOARGS)
        ])

    def on_activated(self):
        # バイナリ文字列を変換・改行コードでリスト化
        self.repos = subprocess.run(
            'powershell -ExecutionPolicy Bypass ghq list',
            shell=True, stdout=subprocess.PIPE, check=True
        ).stdout.decode('utf-8').split()


class SrcWindows(_BasePlugin):
    def __init__(self):
        super().__init__()
        self.open_command = "code"

    def on_start(self):
        """初期化"""
        super().on_start()
        self.root_path = subprocess.run(
            'powershell -ExecutionPolicy Bypass $env:UserProfile',
            shell=True, stdout=subprocess.PIPE, check=True
        ).stdout.decode('utf-8').strip() + "\src"

    def on_catalog(self):
        """
        カタログ生成.
        Keypirinha で起動するためのトリガー・説明など.
        """
        # CatalogItem のリストで catalog の変更
        self.set_catalog([
            # CatalogItem 生成
            self.create_item(
                # 入力のカテゴリ
                category=kp.ItemCategory.KEYWORD,
                # 表示名
                label="repos (src folder in Windows)",
                # 説明
                short_desc="Open repositories",
                # 起動キーワード
                target="repos_src_win",
                # 引数を要求する
                args_hint=kp.ItemArgsHint.REQUIRED,
                # 重複なしで履歴を保存
                hit_hint=kp.ItemHitHint.NOARGS)
        ])

    def on_activated(self):
        # バイナリ文字列を変換・改行コードでリスト化
        self.repos = subprocess.run(
            'powershell -ExecutionPolicy Bypass Get-ChildItem $env:UserProfile\src -Name',
            shell=True, stdout=subprocess.PIPE, check=True
        ).stdout.decode('utf-8').split()


class GhqWsl(_BasePlugin):
    def __init__(self):
        super().__init__()
        self.open_command = "wsl '/mnt/c/Progra~1/Microsoft VS Code/bin/code'"

    def on_start(self):
        """初期化"""
        super().on_start()

        self.root_path = subprocess.run(
            'wsl ~/.go/bin/ghq root',
            shell=True, stdout=subprocess.PIPE, check=True
        ).stdout.decode('utf-8').strip()

    def on_catalog(self):
        """
        カタログ生成.
        Keypirinha で起動するためのトリガー・説明など.
        """
        # CatalogItem のリストで catalog の変更
        self.set_catalog([
            # CatalogItem 生成
            self.create_item(
                # 入力のカテゴリ
                category=kp.ItemCategory.KEYWORD,
                # 表示名
                label="repos (ghq for Ubuntu)",
                # 説明
                short_desc="Open repositories",
                # 起動キーワード
                target="repos_ghq",
                # 引数を要求する
                args_hint=kp.ItemArgsHint.REQUIRED,
                # 重複なしで履歴を保存
                hit_hint=kp.ItemHitHint.NOARGS)
        ])

    def on_activated(self):
        self.repos = subprocess.run(
            'wsl ~/.go/bin/ghq list',
            shell=True, stdout=subprocess.PIPE, check=True
        ).stdout.decode('utf-8').split()
