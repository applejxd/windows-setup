<#
  .SYNOPSIS
    Install everything
#>

Function winst {
    $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
    Invoke-Expression $cmd
}
  
winst voidtools.Everything

#------------------#    
# Software configs #
#------------------#

# Everything
cmd /c rmdir /s /q $env:AppData\Everything
cmd /c mklink /D $env:AppData\Everything $env:UserProfile\src\windows-setup\tools\Everything
