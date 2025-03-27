# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import sys

sys.path.insert(0, os.path.abspath("../../"))

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "project_name"  # TODO: overwrite
copyright = "2023, author_name"  # TODO: overwrite
author = "author_name"  # TODO: overwrite

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    # docstring 使用
    "sphinx.ext.autodoc",
    # ソースコードへの link を追加
    # ビルドが止まることがあるため注意 (その場合は一旦コメントアウトする)
    "sphinx.ext.viewcode",
    # 各種図生成
    "sphinx.ext.graphviz",
    # 継承関係図生成
    "sphinx.ext.inheritance_diagram",
    # Markdown 対応
    "sphinx_mdinclude",
]

# 型ヒントを有効
autodoc_typehints = "description"
# __init__()も出力
autoclass_content = "both"
autodoc_default_options = {
    # プライベートメソッドも出力
    "private-members": True,
    # 継承を表示
    "show-inheritance": True,
}

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

language = "ja"

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]

# -- Options for LaTeX output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-latex-output
# https://www.sphinx-doc.org/en/master/latex.html

latex_engine = "lualatex"
latex_docclass = {"manual": "ltjsbook"}
latex_elements = {
    # (C) Polyglossiaパッケージを読み込まないようにする
    "polyglossia": "",
    # ブランクページを削除
    # 参考：https://stackoverflow.com/questions/5422997/sphinx-docs-remove-blank-pages-from-generated-pdfs
    "extraclassoptions": "openany,oneside",
#     # カスタムヘッダー・フッター
#     "preamble": """
# \makeatletter
#   \fancypagestyle{normal}{
#     \fancyhf{}
#     \fancyfoot[LE,RO]{{\py@HeaderFamily\thepage}}
#     \fancyfoot[LO]{{\py@HeaderFamily\nouppercase{\rightmark}}}
#     \fancyfoot[RE]{{\py@HeaderFamily\nouppercase{\leftmark}}}
#     \fancyhead[LE,RO]{{\py@HeaderFamily \@title, \py@release}}
#     \renewcommand{\headrulewidth}{0.4pt}
#     \renewcommand{\footrulewidth}{0.4pt}
#     % define chaptermark with \@chappos when \@chappos is available for Japanese
#     \spx@ifundefined{@chappos}{}
#       {\def\chaptermark##1{\markboth{\@chapapp\space\thechapter\space\@chappos\space ##1}{}}}
#   }
# \makeatother
# """,
}
