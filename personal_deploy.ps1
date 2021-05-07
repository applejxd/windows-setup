# 個人設定

# 特殊フォルダのパス取得のために Shell オブジェクトの生成
$wsh = New-Object -ComObject WScript.Shell

# gitconfig
if (Test-Path $env:UserProfile\.gitconfig) {
  Remove-Item $env:UserProfile\.gitconfig
}
cmd /c mklink $env:UserProfile\.gitconfig $env:UserProfile\src\windows-setup\config\.gitconfig

# PowerShell
$path = $wsh.SpecialFolders("MyDocuments") + "\WindowsPowerShell"
if (Test-Path $path\Microsoft.PowerShell_profile.ps1) {
  Remove-Item $path\Microsoft.PowerShell_profile.ps1 
}
cmd /c mklink $path\Microsoft.PowerShell_profile.ps1 $env:UserProfile\src\windows-setup\config\Microsoft.PowerShell_profile.ps1

# Windows Terminal
if (Test-Path $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json) {
  Remove-Item $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json 
}
cmd /c mklink $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json $env:UserProfile\src\windows-setup\config\settings.json
