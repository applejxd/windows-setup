# Memo: Japanese comments cause new line error

Function winst {
  $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
  Invoke-Expression $cmd
}

# To avoid Internet Explorer initialization
Function Invoke-UpdatedWebRequest {
  $version = $PSVersionTable.PSVersion.Major
  if ($version -le 5) {
    $cmd = "Invoke-WebRequest $args -UseBasicParsing" 
  }
  else {
    $cmd = "Invoke-WebRequest $args" 
  }
  Invoke-Expression $cmd
}

#-------#
# Scoop #
#-------#

if (!(Get-Command scoop -ea SilentlyContinue)) {
  Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}
scoop install sudo vim git ghq fzf gow which sed gawk pdftk

#------------#
# Keypirinha #
#------------#

$install_dir = "$env:UserProfile\src\windows-setup\tools\Keypirinha\InstalledPackages"
if (-not (Test-Path $install_dir)) {
  New-Item $install_dir -ItemType Directory
}

# function for downloading Keypirinha extensions
function InstallRelease($repo_name, $file_path) { 
  if (-not (Test-Path $install_dir\$file_path)) {
    # GitHub Release API
    $uri = "https://api.github.com/repos/" + $repo_name + "/releases/latest"
    # Read json
    $json = Invoke-UpdatedWebRequest $uri | ConvertFrom-Json
    # Get URL
    $url = $json.assets.browser_download_url
    # Download
    Invoke-UpdatedWebRequest $url -OutFile $file_path
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

Invoke-UpdatedWebRequest "https://github.com/EhsanKia/keypirinha-plugins/raw/master/keypirinha-steam/build/Steam.keypirinha-package" -OutFile "$install_dir/Steam.keypirinha-package"
