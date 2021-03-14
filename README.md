# windows-setup

Initialize Windows 10 by Chocolatey and Boxstarter

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/sw_deploy.ps1'))
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/personal_deploy.ps1'))
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/init.ps1'))
```