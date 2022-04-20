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
# cf. https://docs.microsoft.com/en-us/powershell/module/ scheduledtasks/register-scheduledtask?view=windowsserver2022-ps

$Sta = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy RemoteSigned $env:UserProfile\src\windows-setup\config\wsl_port.ps1"
$Stt = New-ScheduledTaskTrigger -AtLogon
    
Register-ScheduledTask -TaskName "WSL Port Forwarding" -RunLevel Highest -Action $Sta -Trigger $Stt