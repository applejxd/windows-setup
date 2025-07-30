<#
  .SYNOPSIS
    Install packages  
#>

# Memo: Japanese comments cause new line error

#---------#
# Install #
#---------#

Function Invoke-RemoteScript($url) {
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($url))
}

Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/winget.ps1')
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/develop.ps1')

Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/vscode.ps1')
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/font.ps1')

# utility
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/keyhac.ps1')
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/keypirinha.ps1')
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/quicklook.ps1')
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/everything.ps1')

# folder
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/regkey/7zip.ps1')
Invoke-RemoteScript('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/regkey/folder.ps1')

#-----------------#
# Windows Configs #
#-----------------#

# カバーを閉じたらスリープ
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1
powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1

#--------------#
# Link Configs #
#--------------#

$path = "$env:UserProfile\src\windows-setup"
if (-not (Test-Path $path)) {
  git clone --recursive https://github.com/applejxd/windows-setup.git $path
}

# PowerShell Config
# see https://qiita.com/smicle/items/0ca4e6ae14ea92000d18
# see https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.2
if (-not (Test-Path $Profile.CurrentUserAllHosts)) {
  # Make directories
  New-Item $Profile.CurrentUserAllHosts -type file -Force
}
if (-not ((Get-ItemProperty $Profile.CurrentUserAllHosts).Mode.Substring(5, 1) -eq 'l')) {
  # Remove temporary file
  Remove-Item $Profile.CurrentUserAllHosts
}
# PowerShell 5.1
cmd /c mklink $env:UserProfile\Documents\WindowsPowerShell\profile.ps1 $env:UserProfile\src\windows-setup\config\profile.ps1
# PowerShell 7
cmd /c mklink $env:UserProfile\Documents\PowerShell\profile.ps1 $env:UserProfile\src\windows-setup\config\profile.ps1

# Windows Terminal Config
$path = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $path) {
  Remove-Item $path
}
cmd /c mklink $path $env:UserProfile\src\windows-setup\config\settings.json

# WSL2 config
cmd /c mklink $env:UserProfile\.wslconfig $env:UserProfile\src\windows-setup\config\.wslconfig

# PowerToys config
$path = "$env:LocalAppData\Microsoft\PowerToys\NewPlus\Template"
if (Test-Path $path) { 
  Remove-Item $path
} 
cmd /c mklink /D $path $env:UserProfile\src\windows-setup\tools\NewPlus

# Claude Desktop config
$path = "$env:AppData\Claude\claude_desktop_config.json"
if (Test-Path $path) {
  Remove-Item $path
}
cmd /c mklink $path $env:UserProfile\src\windows-setup\config\claude_desktop_config.json