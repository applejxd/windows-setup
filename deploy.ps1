# Memo: Japanese comments cause new line error

#------------#
# Boxstarter #
#------------#

# cf. https://boxstarter.org/Learn/WebLauncher

# Install boxstarter (and chocolatey simultaneously)
. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
# Run script
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box.ps1" -DisableReboots
