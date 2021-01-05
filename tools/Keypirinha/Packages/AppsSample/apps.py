# cf. https://keypirinha.com/api/plugin.html
import keypirinha as kp
import keypirinha_util as kpu

from collections import namedtuple
import datetime
import os

#　処理結果のタプル定義
AnswerTuple = namedtuple('AnswerTuple', ('value', 'datetime'))


class YesNo(kp.Plugin):
    """A simple "Yes or No" plugin"""

    ITEMCAT_RESULT = kp.ItemCategory.USER_BASE + 1

    # 処理結果を保存するリスト
    history = []

    def __init__(self):
        super().__init__()

    def on_start(self):
        """初期化"""
        self.history = []

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
        # CatalogItem のリストで catalog の変更
        self.set_catalog([
            # CatalogItem 生成
            self.create_item(
                # 入力のカテゴリ
                category=kp.ItemCategory.KEYWORD,
                # 表示名
                label="YesNo",
                # 説明
                short_desc="Yes or No",
                # 起動キーワード
                target="yesno",
                # 引数を要求する
                args_hint=kp.ItemArgsHint.REQUIRED,
                # 重複なしで履歴を保存
                hit_hint=kp.ItemHitHint.NOARGS)
        ])

    def on_suggest(self, user_input, items_chain):
        """検索処理

        Args:
            user_input : 入力内容
            items_chain : 選択したアイテム
        """
        # カテゴリが異なる場合
        if not items_chain or items_chain[-1].category() != kp.ItemCategory.KEYWORD:
            return

        # 入力内容がない場合
        if not user_input:
            self.history = []

        # 結果を履歴に追加
        self.history.append(AnswerTuple(
            os.urandom(1)[0] % 2,
            datetime.datetime.now()))

        # サジェスト作成
        suggestions = []
        # 降順ループ
        for idx in range(len(self.history) - 1, -1, -1):
            answer = self.history[idx]
            # メッセージ
            desc = "{}. {} (press Enter to copy)".format(
                idx + 1, answer.datetime.strftime("%H:%M:%S"))
            # サジェスト追加
            suggestions.append(
                # CatalogItem オブジェクト生成
                self.create_item(
                    category=self.ITEMCAT_RESULT,
                    label=self._value_to_string(answer.value),
                    short_desc=desc,
                    target="{},{}".format(answer.value, idx),
                    args_hint=kp.ItemArgsHint.FORBIDDEN,
                    hit_hint=kp.ItemHitHint.IGNORE)
            )

        # サジェスト表示
        self.set_suggestions(suggestions, kp.Match.ANY, kp.Sort.NONE)

    def on_execute(self, item, action):
        """実行処理

        Args:
            item : CatalogItem
            action : 
        """
        if item and item.category() == self.ITEMCAT_RESULT:
            value = int(item.target().split(',', maxsplit=1)[0])
            # クリップボードに保存
            kpu.set_clipboard(self._value_to_string(value))

    def _value_to_string(self, value):
        # 三項演算子で string に変換
        return "Yes" if value else "No"
