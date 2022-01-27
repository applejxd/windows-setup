# WSL2のIPアドレスを取得
$WSL2_IPV4=(wsl bash /mnt/c/Users/$env:UserName/src/windows-setup/config/get_ipv4.bash)
$HOST_IPV4=((Get-WmiObject Win32_NetworkAdapterConfiguration).IPAddress)[1]
$PORT=22000

# 古い設定を削除
netsh interface portproxy delete v4tov4 listenport=$PORT
# ホストIP:PORTへアクセスがあったら、WSL2_IP:PORTに転送します。
netsh interface portproxy add v4tov4 listenaddress=$HOST_IPV4 listenport=$PORT connectaddress=$WSL2_IPV4 connectport=22