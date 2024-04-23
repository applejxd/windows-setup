<#
  .SYNOPSIS
    Install quicklook for windows
#>

Function winst {
    $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
    Invoke-Expression $cmd
}

winst QL-Win.QuickLook

#---------#
# Startup #
#---------#

$wsh = New-Object -ComObject WScript.Shell

$path = $wsh.SpecialFolders("Startup") + "\QuickLook.lnk"
if (-not (Test-Path $path)) {
    $shortcut = $wsh.CreateShortcut($path)
  
    $shortcut.WorkingDirectory = $env:LOCALAPPDATA + "\Programs\QuickLook\QuickLook.exe"
    $shortcut.TargetPath = $env:LOCALAPPDATA + "\Programs\QuickLook\QuickLook.exe"
    $shortcut.IconLocation = $env:LOCALAPPDATA + "\Programs\QuickLook\QuickLook.exe"
  
    $shortcut.Save()
}
