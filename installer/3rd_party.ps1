# To avoid Internet Explorer initialization
function My-Invoke-WebRequest() {
  $version = $PSVersionTable.PSVersion.Major
  if ($version -le 5) {
    $cmd = "Invoke-WebRequest $args -UseBasicParsing" 
  } else {
    $cmd = "Invoke-WebRequest $args" 
  }
  Invoke-Expression $cmd
}

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
    $json = My-Invoke-WebRequest $uri | ConvertFrom-Json
    # Get URL
    $url = $json.assets.browser_download_url
    # Download
    My-Invoke-WebRequest $url -OutFile $file_path
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

My-Invoke-WebRequest "https://github.com/EhsanKia/keypirinha-plugins/raw/master/keypirinha-steam/build/Steam.keypirinha-package" -OutFile "$install_dir/Steam.keypirinha-package"

#############
# QuickLook #
#############

$json = My-Invoke-WebRequest "https://api.github.com/repos/QL-Win/QuickLook/releases/latest" | ConvertFrom-Json
$url = $json.assets.browser_download_url[1]
My-Invoke-WebRequest $url -OutFile C:/tools/QuickLook.zip
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
