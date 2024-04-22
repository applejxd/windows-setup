<#
  .SYNOPSIS
    Introduce sshd in Windows
  .DESCRIPTION
    from https://docs.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_install_firstuse
    from https://takuya-1st.hatenablog.jp/entry/2022/03/04/171043
#>


#---------#
# Install #
#---------#

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

#---------#
# Service #
#---------#

Start-Service sshd
# OPTIONAL but recommended
Set-Service -Name sshd -StartupType 'Automatic'

#---------#
# Network #
#---------#

# set firewall rule
netsh advfirewall firewall add rule name="sshd" dir=in action=allow protocol=TCP localport=22

# # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
# if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
#     Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
#     New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
# } else {
#     Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
# }

#-------#
# Shell #
#-------#

# set default shell
# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\system32\bash.exe" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
