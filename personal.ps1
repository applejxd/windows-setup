
$wsh = New-Object -ComObject WScript.Shell

##########
# Config #
##########

git config --global user.name applejxd
git config --global user.email 9639592+applejxd@users.noreply.github.co

########
# Font #
########

# cf. https://stackoverflow.com/questions/16023238/installing-system-font-with-powershell

# The CLSID of the special folder
# cf. https://tarma.com/support/im9/using/symbols/functions/csidls.htm
Invoke-WebRequest https://github.com/mzyy94/RictyDiminished-for-Powerline/raw/master/powerline-fontpatched/Ricty%20Diminished%20Regular%20for%20Powerline.ttf -OutFile $Home\RictyDiminished-for-Powerline.ttf
(New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$Home\RictyDiminished-for-Powerline.ttf", 0x10)
Remove-Item $Home\RictyDiminished-for-Powerline.ttf

##############
# Boxstarter #
##############

# Install boxstarter (and chocolatey simultaneously)
. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force

Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box_install.ps1" -DisableReboots

####################    
# Software configs #
####################

# Keyhac
cmd /c rmdir /s /q $env:AppData\Keyhac
cmd /c mklink /D $env:AppData\Keyhac $env:UserProfile\src\windows-setup\tools\Keyhac
$install_path = "$env:AppData\Keyhac\extension\fakeymacs"
if (-not (Test-Path $install_path)){
  git clone https://github.com/smzht/fakeymacs.git $install_path
}

# Keypirinha
cmd /c rmdir /s /q $env:AppData\Keypirinha
cmd /c mklink /D $env:AppData\Keypirinha $env:UserProfile\src\windows-setup\tools\Keypirinha

# Everything
cmd /c rmdir /s /q $env:AppData\Everything
cmd /c mklink /D $env:AppData\Everything $env:UserProfile\src\windows-setup\tools\Everything

##############
# Keypirinha #
##############

$install_dir = "$env:UserProfile\src\windows-setup\tools\Keypirinha\InstalledPackages"
if (-not (Test-Path $install_dir)){
  New-Item $install_dir -ItemType Directory
}

# function for downloading Keypirinha extensions
function InstallRelease($repo_name, $file_path) { 
  if (-not (Test-Path $install_dir\$file_path)){
    # GitHub Release API
    $uri = "https://api.github.com/repos/" + $repo_name + "/releases/latest"
    # Read json
    $json = Invoke-WebRequest $uri | ConvertFrom-Json
    # Get URL
    $url = $json.assets.browser_download_url
    # Download
    Invoke-WebRequest $url -OutFile $file_path
  }
}

InstallRelease "Fuhrmann/keypirinha-url-shortener" "$install_dir\URLShortener.keypirinha-package"
InstallRelease "psistorm/keypirinha-systemcommands" "$install_dir\SystemCommands.keypirinha-package"
InstallRelease "clinden/keypirinha-colorpicker" "$install_dir\ColorPicker.keypirinha-package"
InstallRelease "dozius/keypirinha-snippets" "$install_dir\Snippets.keypirinha-package"
# Clipborad Manager
InstallRelease "tuteken/Keypirinha-Plugin-Ditto" "$install_dir\Ditto.keypirinha-package"
# Default Windows Apps
InstallRelease "ueffel/Keypirinha-WindowsApps" "$install_dir\WindowsApps.keypirinha-package"
# Windows Terminal Profiles
InstallRelease "fran-f/keypirinha-terminal-profiles" "$install_dir\Terminal-Profiles.keypirinha-package"
# Search by abbrev
InstallRelease "bantya/Keypirinha-EasySearch" "$install_dir\EasySearch.keypirinha-package"
# Execute commands from >
InstallRelease "bantya/Keypirinha-Command" "$install_dir\Command.keypirinha-package"

Invoke-WebRequest "https://github.com/EhsanKia/keypirinha-plugins/raw/master/keypirinha-steam/build/Steam.keypirinha-package" -OutFile "$install_dir/Steam.keypirinha-package"

#############
# QuickLook #
#############

$json = Invoke-WebRequest "https://api.github.com/repos/QL-Win/QuickLook/releases/latest" | ConvertFrom-Json
$url = $json.assets.browser_download_url[1]
Invoke-WebRequest $url -OutFile C:/tools/QuickLook.zip
Expand-Archive -Path C:/tools/QuickLook.zip -DestinationPath C:/tools/QuickLook -Force
Remove-Item C:/tools/QuickLook.zip

###########
# Startup #
###########

$path = $wsh.SpecialFolders("Startup") + "\keyhac.lnk"

if (-not (Test-Path $path)){
  $shortcut = $wsh.CreateShortcut($path)
  
  $shortcut.WorkingDirectory = "C:\ProgramData\chocolatey\bin"
  $shortcut.TargetPath = "C:\ProgramData\chocolatey\bin\keyhac.exe"
  $shortcut.IconLocation = "C:\ProgramData\chocolatey\bin\keyhac.exe"

  $shortcut.Save()
}

$path = $wsh.SpecialFolders("Startup") + "\QuickLook.lnk"

if (-not (Test-Path $path)){
  $shortcut = $wsh.CreateShortcut($path)
  
  $shortcut.WorkingDirectory = "C:\tools\QuickLook"
  $shortcut.TargetPath = "C:\tools\QuickLook\QuickLook.exe"
  $shortcut.IconLocation = "C:\tools\QuickLook\QuickLook.exe"

  $shortcut.Save()
}