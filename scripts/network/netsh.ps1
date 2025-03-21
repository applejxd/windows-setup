# Windows SSH
netsh advfirewall firewall add rule name="OpenSSH Server (Windows)" dir=in action=allow protocol=TCP localport=22
# WSL SSH
netsh advfirewall firewall add rule name="OpenSSH Server (WSL)" dir=in action=allow protocol=TCP localport=50022
# WSL RDP
netsh advfirewall firewall add rule name="xrdp (WSL)" dir=in action=allow protocol=TCP localport=53389