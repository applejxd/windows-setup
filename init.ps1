# NuGet プロバイダー更新
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
# fzf wrapper
Install-Module -Name PSFzf -RequiredVersion 2.1.0 -Scope CurrentUser -Force
# z コマンド
Install-Module ZLocation -Scope CurrentUser -Force

# oh-my-posh v2 for PowerShell v5.1
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force

##############
# Chocolatey #
##############

# Chocolatey のインストール
# if(!(gcm choco -ea SilentlyContinue)) {
#   iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# }

# choco install -y Boxstarter
# Boxstarter のコマンドレットを Powershell に追加
# Import-Module Boxstarter.Chocolatey

#########
# Scoop #
#########

if(!(Get-Command scoop -ea SilentlyContinue)) {
  Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}
scoop install sudo vim
scoop install ghq fzf
scoop install which
scoop install sed gawk
# git config --global ghq.root ~/src

#######
# WSL #
#######

# cf. https://netlog.jpn.org/r271-635/2021/08/windows10ver21h1_wsl2_inst.html
# cf. https://minettyo.com/entry/wsl_wsl2conversion

# wsl --list --verbose
# wsl --install -d Ubuntu-20.04
# wsl --update

# WSL2 へ変更
# wsl --set-version Ubuntu-20.04 2
# wsl --set-default-version2

# バージョン確認
# wsl --status

#######
# Git #
#######

git config --global init.defaultBranch main

git config --global core.editor vim
git config --global core.ignorecase false
git config --global core.quotepath false

git config --global ghq.root ~/src

git config --global gitflow.branch.master main

########
# sshd #
########

# cf. https://docs.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_install_firstuse

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd
# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

###########################
# Port Forwarding for WSL #
###########################

# cf. https://zenn.dev/fate_shelled/scraps/f6252654277ca0
# cf. http://sloppy-content.blog.jp/archives/11834895.html
# cf. https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/register-scheduledtask?view=windowsserver2022-ps

$Trigger = New-ScheduledTaskTrigger -AtStartup
$PS = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy RemoteSigned $env:UserProfile\src\windows-setup\config\wsl_por.ps1"
Register-ScheduledTask -TaskName "WSL Port Forwarding" -RunLevel Highest -Trigger $Trigger -Action $PS