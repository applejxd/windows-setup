# WSL2のIPアドレスを取得
$WSL2_IPV4=bash ~/get_ipv4.bash
$HOST_IPV4="ホストPCのIPアドレス"
# SSHのポート
$PORT=22

# 古い設定を削除
netsh interface portproxy delete v4tov4 listenport=$PORT
# ホストIP:PORTへアクセスがあったら、WSL2_IP:PORTに転送します。
netsh interface portproxy add v4tov4 listenaddress=$HOST_IPV4 listenport=$PORT connectaddress=$WSL2_IPV4 connectport=$PORT