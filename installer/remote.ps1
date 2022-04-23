#------#
# sshd #
#------#

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

#----------#
# Firewall #
#----------#

# 設定パラメータ
$base_port_array = 50022, 53389, 58888
$port_name_array = "SSH", "RDP", "HTTP"
$range=20

for ($port_index=0; $port_index -lt $base_port_array.Count; $port_index++){
    for ($shift_index=0; $shift_index -lt $range; $shift_index++){
        $port_num = $base_port_array[$port_index] + $shift_index

        # ポート開放
        $rule_name = "WSL-" + $port_name_array[$port_index] + "-" + [string]$shift_index
        if (!(Get-NetFirewallRule -Name $rule_name -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
            New-NetFirewallRule -Name $rule_name -DisplayName $rule_name -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $port_num
            # Remove-NetFireRule -DisplayName $rule_name
        }
    }
}

# 確認コマンド
# netsh interface portproxy show all