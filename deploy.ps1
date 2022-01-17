# Memo: Japanese comments cause new line error

# for special folders
$wsh = New-Object -ComObject WScript.Shell

#################
# Symbolic Link #
#################

$install_path = "$env:UserProfile\src\windows-setup"
if (-not (Test-Path $install_path)){
  git clone https://github.com/applejxd/windows-setup.git $install_path
}

# PowerShell
# Set-ExecutionPolicy RemoteSigned
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
