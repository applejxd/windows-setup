# フォルダの有無で初期化実行
if (-Not(Test-Path sphinx)) {
    $ProjectName = Convert-Path $ScriptDir\.. | Split-Path -Leaf
    sphinx-quickstart -q -p $ProjectName -a applejxd -v 0.1 -l ja sphinx
}

# ドキュメント生成
sphinx-apidoc -e -f -o $ScriptDir\sphinx .
sphinx-build -a $ScriptDir\sphinx $ScriptDir\docs

Set-Location $ScriptDir\sphinx
make latexpdfja
Set-Location $ScriptDir