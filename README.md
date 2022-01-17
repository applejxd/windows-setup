# windows-setup

Initialize Windows 10 by Chocolatey and Boxstarter

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/init.ps1'))
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/deploy.ps1'))
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/link.ps1'))
```

Boxstarter configs:
```powershell
# Install boxstarter (and chocolatey simultaneously)
. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force

# configurations
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box_config.ps1" -DisableReboots
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box_install.ps1" -DisableReboots
```
