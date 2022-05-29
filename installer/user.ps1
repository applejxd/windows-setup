# Memo: Japanese comments cause new line error

Function winst {
    winget install --silent --accept-package-agreements --accept-source-agreements $args
}

# To avoid Internet Explorer initialization
Function My-Invoke-WebRequest {
  $version = $PSVersionTable.PSVersion.Major
  if ($version -le 5) {
    $cmd = "Invoke-WebRequest $args -UseBasicParsing" 
  } else {
    $cmd = "Invoke-WebRequest $args" 
  }
  Invoke-Expression $cmd
}

#-------#
# Scoop #
#-------#

if(!(Get-Command scoop -ea SilentlyContinue)) {
    Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}
scoop install sudo vim ghq fzf which sed gawk pdftk

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
if (Test-Path $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json) {
  Remove-Item $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json 
}
cmd /c mklink $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json $env:UserProfile\src\windows-setup\config\settings.json

#------------------#    
# Software configs #
#------------------#

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

#------------#
# Keypirinha #
#------------#

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
