# 個人設定

# gitconfig
cmd /c mklink $env:UserProfile\.gitconfig $env:UserProfile\src\windows-setup\config\.gitconfig

# PowerShell
$path = $wsh.SpecialFolders("MyDocuments") + "\WindowsPowerShell"
Remove-Item $path\Microsoft.PowerShell_profile.ps1 
cmd /c mklink $path\Microsoft.PowerShell_profile.ps1 $env:UserProfile\src\windows-setup\config\Microsoft.PowerShell_profile.ps1

# # Windows Terminal
# Remove-Item $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json 
# cmd /c mklink $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json $env:UserProfile\src\windows-setup\config\settings.json