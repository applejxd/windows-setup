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

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
