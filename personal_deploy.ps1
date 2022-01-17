# 個人設定

# 特殊フォルダのパス取得のために Shell オブジェクトの生成
$wsh = New-Object -ComObject WScript.Shell

# gitconfig
if (Test-Path $env:UserProfile\.gitconfig) {
  Remove-Item $env:UserProfile\.gitconfig
}
cmd /c mklink $env:UserProfile\.gitconfig $env:UserProfile\src\windows-setup\config\.gitconfig
