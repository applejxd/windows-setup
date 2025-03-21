# Windows SSH
netsh advfirewall firewall add rule name="sshd_win" dir=in action=allow protocol=TCP localport=22
# WSL SSH
netsh advfirewall firewall add rule name="sshd_wsl" dir=in action=allow protocol=TCP localport=50022
# WSL RDP
netsh advfirewall firewall add rule name="xrdp" dir=in action=allow protocol=TCP localport=53389