# windows-setup

Initialize Windows 10 by Chocolatey and Boxstarter

## How To Use

1. Run a script as administrator
   
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/deploy.ps1'))
   ```
   
2. Run a script as current user

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/user.ps1'))
   ```

3. Enable profile.ps1

   ```powershell
   Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
   ```
