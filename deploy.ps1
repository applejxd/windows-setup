# Memo: Japanese comments cause new line error

Function winst {
    winget install --silent --accept-package-agreements --accept-source-agreements $args
}

#-------#
# Scoop #
#-------#

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module RunAsUser

if(!(Get-Command scoop -ea SilentlyContinue)) {
    $scriptblock = Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
    Invoke-AsCurrentUser -scriptblock $scriptblock
}
$scriptblock = scoop install sudo vim ghq fzf which sed gawk pdftk
Invoke-AsCurrentUser -scriptblock $scriptblock

#------------#
# Boxstarter #
#------------#

# cf. https://boxstarter.org/Learn/WebLauncher

# Install boxstarter (and chocolatey simultaneously)
sudo . { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
# Run script
sudo Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box.ps1" -DisableReboots

# 3rd party
sudo Invoke-Expression ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/3rd_party.ps1'))

#--------------#
# Link Configs #
#--------------#

$install_path = "$env:UserProfile\src\windows-setup"
if (-not (Test-Path $install_path)){
  if (!(Get-Command git -ea SilentlyContinue)) {
    winst Git.Git
    $env:Path="C:\Progra~1\Git\bin;"+$env:Path
  }
  git clone https://github.com/applejxd/windows-setup.git $install_path
}

# PowerShell Config
# cf. https://qiita.com/smicle/items/0ca4e6ae14ea92000d18
# cf. https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.2 
if (!(Test-Path $Profile.CurrentUserAllHosts)) {
  # Make directories
  New-Item $Profile.CurrentUserAllHosts -type file -Force
}
if (!((Get-ItemProperty $Profile.CurrentUserAllHosts).Mode.Substring(5,1) -eq 'l')) {
  # Remove temporary file
  Remove-Item $Profile.CurrentUserAllHosts
}
cmd /c mklink $Profile.CurrentUserAllHosts $env:UserProfile\src\windows-setup\config\profile.ps1

# Windows Terminal Config
winst Microsoft.WindowsTerminal
if (Test-Path $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json) {
  Remove-Item $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json 
}
cmd /c mklink $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json $env:UserProfile\src\windows-setup\config\settings.json
