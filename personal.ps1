git config --global user.name applejxd
git config --global user.email 9639592+applejxd@users.noreply.github.com

Function winst {
    $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
    Invoke-Expression $cmd
}

# iCloud
winst 9PKTQ5699M62
# Spotify from Microsoft Store
winst 9NCBCSZSJRSB

winst Piriform.Recuva
winst Apple.iTunes
winst Valve.Steam
winst Amazon.Kindle
winst Discord.Discord
winst Wacom.WacomTabletDriver

cinst mo2 vortex