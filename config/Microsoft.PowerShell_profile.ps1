# エンコーディングを US-ASCII から変更
# cf. https://dattesar.com/powershell-utf8/
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# cf. https://secon.dev/entry/2020/08/17/070735/

# テーマ
# OneDrive の MyDocuments 同期は非推奨（パスが変更されるため）
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt Paradox

# キーバインド
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
# 標準だと Ctrl+d は DeleteCharOrExit のため、うっかり端末が終了することを防ぐ
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

#########
# alias #
#########

Set-Alias open explorer.exe
Set-Alias pbcopy clip.exe
Set-Alias pbpaste 'powershell.exe Get-Clipboard'

#######
# fzf #
#######
#cf. https://github.com/junegunn/fzf/wiki/Windows

$env:FZF_DEFAULT_OPTS="--reverse --border"

# C-t と C-r のラッパー
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# ghq-fzf
# C-x C-g のキーバインドに関数割り当て
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+g' -ScriptBlock {
  $path = ghq list | fzf
  # パスが空の文字列でなければ実行
  if (!([string]::IsNullOrEmpty($path))) {
    Set-Location "$(ghq root)\$path"
    # バッファの内容を実行
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  # 画面をクリア
  Clear-Host
}

# z-fzf
Import-Module ZLocation
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+f' -ScriptBlock {
  # ZLocation の一覧オブジェクトの Path プロパティ抜き出し
  $path =  z -l | ForEach-Object {Write-Output $_.Path} | fzf
  if (!([string]::IsNullOrEmpty($path))) {
    Set-Location "$path"
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  Clear-Host
}

function wbk {
  # Where-Object で空行削除
  $distro = wsl -l -q | Where-Object{$_ -ne ""} | fzf
  # null 文字を削除
  # cf. https://stackoverflow.com/questions/9863455/how-to-remove-null-char-0x00-from-object-within-powershell
  $distro = $distro -replace "`0",""
  $date = Get-Date -UFormat "%y.%m.%d"
  # https://sevenb.jp/wordpress/ura/2016/06/01/powershell%E6%96%87%E5%AD%97%E5%88%97%E5%86%85%E3%81%AE%E5%A4%89%E6%95%B0%E5%B1%95%E9%96%8B%E3%81%A7%E5%A4%89%E6%95%B0%E5%90%8D%E3%82%92%E7%A2%BA%E5%AE%9A%E3%81%95%E3%81%9B%E3%82%8B/
  wsl --export "${distro}" "${distro}_${date}.tar"
}
