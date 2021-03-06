# Scoop のインストール
Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
scoop install sudo vim
scoop install ghq fzf
scoop install sed gawk
git config --global ghq.root ~/src

# fzf wrapper
Install-Module -Name PSFzf -RequiredVersion 2.1.0 -Scope CurrentUser -Force
# z コマンド
Install-Module ZLocation -Scope CurrentUser -Force

# oh-my-posh v2 for PowerShell v5.1
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force

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
