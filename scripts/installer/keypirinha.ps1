<#
  .SYNOPSIS
    Install keypirinha and its extentions
  .DESCRIPTION
    Install keypirinha via chocolatey
#>

# ---------- #
# Keypirinha #
# ---------- #

# Install chocolatey
if (-not (Get-Command choco -ea SilentlyContinue)) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco install chocolateygui
choco install Keypirinha

# ---------- #
# Extensions #
# ---------- #

$install_dir = "$env:UserProfile\src\windows-setup\tools\Keypirinha\InstalledPackages"
if (-not (Test-Path $install_dir)) {
    New-Item $install_dir -ItemType Directory
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

#--------------#
# Link Configs #
#--------------#

# download configs
$path = "$env:UserProfile\src\windows-setup"
if (-not (Test-Path $path)) {
    git clone https://github.com/applejxd/windows-setup.git $path
}

# Keypirinha
cmd /c rmdir /s /q $env:AppData\Keypirinha
cmd /c mklink /D $env:AppData\Keypirinha $env:UserProfile\src\windows-setup\tools\Keypirinha
