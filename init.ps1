# Chocolatey のインストール
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y Boxstarter

# Boxstarter のコマンドレットを Powershell に追加
Import-Module Boxstarter.Chocolatey

# Install boxstarter and chocolatey simultaneously
# . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force

# Boxstarter スクリプト実行
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/boxstarter.ps1" -DisableReboots
