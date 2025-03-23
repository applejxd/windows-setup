git config --global user.name applejxd
git config --global user.email 9639592+applejxd@users.noreply.github.com

Function winst {
    $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
    Invoke-Expression $cmd
}

winst Bitwarden.Bitwarden
winst Apple.iCloud
winst Apple.iTunes

winst Spotify.Spotify
winst Valve.Steam
winst Amazon.Kindle
winst Discord.Discord
winst Wacom.WacomTabletDriver

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

# for Steam
Invoke-UpdatedWebRequest "https://github.com/EhsanKia/keypirinha-plugins/raw/master/keypirinha-steam/build/Steam.keypirinha-package" -OutFile "$install_dir/Steam.keypirinha-package"

# cinst mo2 vortex
# winst Piriform.Recuva

# # WSL
# wsl --install
# wsl --import-in-place Ubuntu "D:\wsl\Ubuntu\ext4.vhdx"