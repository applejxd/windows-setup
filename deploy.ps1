# Memo: Japanese comments cause new line error

#------------#
# Boxstarter #
#------------#

# cf. https://boxstarter.org/Learn/WebLauncher

if (-not (gcm Install-BoxstarterPackage -ea SilentlyContinue)) {
  # Install boxstarter (and chocolatey simultaneously)
  . { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
}
# Run script
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box.ps1" -DisableReboots

#--------#
# Keyhac #
#--------#

# Fakeymacs needs Keyhac>=1.82
if (-not (Test-Path "C:\Progra~1\keyhac")) {
  $url = "http://crftwr.github.io/keyhac/download/keyhac_182.zip"
  Invoke-WebRequest "$url" -OutFile "$Home\keyhac.zip"
  Expand-Archive -Path "$Home\keyhac.zip" -DestinationPath "C:\Progra~1"
  Remove-Item "$Home\keyhac.zip"
}

#------#
# Font #
#------#

# cf. https://stackoverflow.com/questions/16023238/installing-system-font-with-powershell

if (-not ([System.String]::Join(" ",[System.Drawing.FontFamily]::Families)).Contains("Ricty Diminished for Powerline")){
  $url = "https://github.com/mzyy94/RictyDiminished-for-Powerline/raw/master/powerline-fontpatched/Ricty%20Diminished%20Regular%20for%20Powerline.ttf"
  Invoke-WebRequest $url -OutFile $Home\RictyDiminished-for-Powerline.ttf
  
  # The CLSID of the special folder
  # cf. https://tarma.com/support/im9/using/symbols/functions/csidls.htm
  (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$Home\RictyDiminished-for-Powerline.ttf", 0x10)
  Remove-Item $Home\RictyDiminished-for-Powerline.ttf
}

if (-not ([System.String]::Join(" ",[System.Drawing.FontFamily]::Families)).Contains("Cica")){
  $url = "https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip"
  Invoke-WebRequest $url -OutFile $Home\Cica.zip
  Expand-Archive -Path $Home\Cica.zip -DestinationPath $Home\Cica
  
  # The CLSID of the special folder
  # cf. https://tarma.com/support/im9/using/symbols/functions/csidls.htm
  (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$Home\Cica\Cica-Regular.ttf", 0x10)
  Remove-Item $Home\Cica.zip
  Remove-Item -Recurse $Home\Cica
}
 
#---------#
# Startup #
#---------#

$wsh = New-Object -ComObject WScript.Shell

$path = $wsh.SpecialFolders("Startup") + "\keyhac.lnk"
if (-not (Test-Path $path)){
  $shortcut = $wsh.CreateShortcut($path)
  
  $shortcut.WorkingDirectory = "C:\Progra~1\keyhac"
  $shortcut.TargetPath = "C:\Progra~1\keyhac\keyhac.exe"
  $shortcut.IconLocation = "C:\Progra~1\keyhac\keyhac.exe"

  $shortcut.Save()
}

$path = $wsh.SpecialFolders("Startup") + "\QuickLook.lnk"
if (-not (Test-Path $path)){
  $shortcut = $wsh.CreateShortcut($path)
  
  $shortcut.WorkingDirectory = $env:LOCALAPPDATA + "\Programs\QuickLook\QuickLook.exe"
  $shortcut.TargetPath = $env:LOCALAPPDATA + "\Programs\QuickLook\QuickLook.exe"
  $shortcut.IconLocation = $env:LOCALAPPDATA + "\Programs\QuickLook\QuickLook.exe"
  
  $shortcut.Save()
}

$path = $wsh.SpecialFolders("Startup") + "\XLaunch.lnk"
if (-not (Test-Path $path)){
  $shortcut = $wsh.CreateShortcut($path)
  
  $shortcut.WorkingDirectory = "$env:UserProfile\src\windows-setup\config"
  $shortcut.TargetPath = "$env:UserProfile\src\windows-setup\config\config.xlaunch"
  $shortcut.IconLocation = "$env:UserProfile\src\windows-setup\config\config.xlaunch"
  
  $shortcut.Save()
}

#--------------#
# Link Configs #
#--------------#

$path = "$env:UserProfile\src\windows-setup"
if (-not (Test-Path $path)){
  git clone https://github.com/applejxd/windows-setup.git $path
}

# PowerShell Config
# cf. https://qiita.com/smicle/items/0ca4e6ae14ea92000d18
# cf. https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.2
if (-not (Test-Path $Profile.CurrentUserAllHosts)) {
  # Make directories
  New-Item $Profile.CurrentUserAllHosts -type file -Force
}
if (-not ((Get-ItemProperty $Profile.CurrentUserAllHosts).Mode.Substring(5,1) -eq 'l')) {
  # Remove temporary file
  Remove-Item $Profile.CurrentUserAllHosts
}
cmd /c mklink $Profile.CurrentUserAllHosts $env:UserProfile\src\windows-setup\config\profile.ps1

# Windows Terminal Config
$path = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $path) {
  Remove-Item $path
}
cmd /c mklink $path $env:UserProfile\src\windows-setup\config\settings.json

#------------------#    
# Software configs #
#------------------#

# Keyhac
cmd /c rmdir /s /q $env:AppData\Keyhac
cmd /c mklink /D $env:AppData\Keyhac $env:UserProfile\src\windows-setup\tools\Keyhac
$path = "$env:AppData\Keyhac\extension\fakeymacs"
if (-not (Test-Path $path)){
  git clone https://github.com/smzht/fakeymacs.git $path
  # For reproducibility. Use a revision at 2021/5/6.
  git -C $path checkout 7192a75
}

# Keypirinha
cmd /c rmdir /s /q $env:AppData\Keypirinha
cmd /c mklink /D $env:AppData\Keypirinha $env:UserProfile\src\windows-setup\tools\Keypirinha

# Everything
cmd /c rmdir /s /q $env:AppData\Everything
cmd /c mklink /D $env:AppData\Everything $env:UserProfile\src\windows-setup\tools\Everything
