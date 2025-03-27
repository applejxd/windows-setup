# 仮想環境のアクティベート
$venvPath = "..\.venv\Scripts\Activate.ps1"
if (Test-Path $venvPath) {
    & $venvPath
} else {
    Write-Error "Virtual environment not found."
    exit 1
}

# Sphinx の API ドキュメント生成
sphinx-apidoc -e -f -M -o .\sphinx ..\src

# 画像ディレクトリのコピー（既存のものを削除してからコピー）
$imgHtmlPath = ".\build\html\img"
$imgLatexPath = ".\build\latex\img"
$srcImgPath = "..\img"

if (Test-Path $imgHtmlPath) { Remove-Item -Recurse -Force $imgHtmlPath }
Copy-Item -Recurse -Force $srcImgPath $imgHtmlPath

if (Test-Path $imgLatexPath) { Remove-Item -Recurse -Force $imgLatexPath }
Copy-Item -Recurse -Force ".\img" $imgLatexPath

# ビルド処理
make html
make latexpdf
