<#
  .SYNOPSIS
    Install Keyhac
#>

# Fakeymacs needs Keyhac>=1.82
if (-not (Test-Path "C:\Progra~1\keyhac")) {
  $url = "http://crftwr.github.io/keyhac/download/keyhac_182.zip"
  Invoke-WebRequest "$url" -OutFile "$Home\keyhac.zip"
  Expand-Archive -Path "$Home\keyhac.zip" -DestinationPath "C:\Progra~1"
  Remove-Item "$Home\keyhac.zip"
}

#---------#
# Startup #
#---------#

$wsh = New-Object -ComObject WScript.Shell

$path = $wsh.SpecialFolders("Startup") + "\keyhac.lnk"
if (-not (Test-Path $path)) {
  $shortcut = $wsh.CreateShortcut($path)
  
  $shortcut.WorkingDirectory = "C:\Progra~1\keyhac"
  $shortcut.TargetPath = "C:\Progra~1\keyhac\keyhac.exe"
  $shortcut.IconLocation = "C:\Progra~1\keyhac\keyhac.exe"

  $shortcut.Save()
}

#------------#
# Start Menu #
#------------#

$wsh = New-Object -ComObject WScript.Shell

$programsFolderPath = $wsh.SpecialFolders.Item("Programs")
$shortcutPath = [System.IO.Path]::Combine($programsFolderPath, "Keyhac.lnk")
if (-not (Test-Path -Path $shortcutPath)) {
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "C:\Progra~1\keyhac\keyhac.exe"
    $shortcut.Save()
}

#-------------#
# Link Config #
#-------------#

# download configs
$path = "$env:UserProfile\src\windows-setup"
if (-not (Test-Path $path)) {
  git clone https://github.com/applejxd/windows-setup.git $path
}

# Symbolic link
cmd /c rmdir /s /q $env:AppData\Keyhac
cmd /c mklink /D $env:AppData\Keyhac $env:UserProfile\src\windows-setup\tools\Keyhac
