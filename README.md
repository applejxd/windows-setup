# windows-setup

Initialize Windows 10 by Chocolatey and Boxstarter

## How To Use

1. Run as Admin
   
   ```powershell
   . { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
   # Run script
   Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box.ps1" -DisableReboots
   ```
   
2. Run as User
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/user.ps1'))
   ```
