# windows-setup

Initialize Windows 10 by Chocolatey and Boxstarter

## How To Use

1. Run a script as administrator via Powershell (not Windows Terminal)

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/deploy.ps1'))
   
   # optional
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/network/sshd.ps1'))
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/scripts/installer/cuda.ps1'))
   ```

2. Run a script as current user

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/scoop.ps1'))
   
   # optional
   iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/applejxd/windows-setup/main/personal.ps1'))
   ```

3. Enable profile.ps1

   ```powershell
   Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
   ```
