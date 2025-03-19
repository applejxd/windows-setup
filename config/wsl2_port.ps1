# Open ports for WSL2
# see https://zenn.dev/fate_shelled/scraps/f6252654277ca0

# WSL2 の IP
$WSL2_IPV4=wsl -e ip address show eth0 | awk '/inet / {print $2}' | awk -F / '{print $1}'
# ホストPCのIPアドレス
$HOST_IPV4="192.168.100.21"

# ベースとするポート番号(ssh, xrdp, http)
$base_port_array = 50022, 53389, 58888
# まとまってポート開放する量
$range=5

for ($port_index=0; $port_index -lt $base_port_array.Count; $port_index++){
    for ($shift_index=0; $shift_index -lt $range; $shift_index++){
        $port_num = $base_port_array[$port_index] + $shift_index

        # 古い設定を削除
        netsh interface portproxy delete v4tov4 listenaddress=$HOST_IPV4 listenport=$port_num
        # ホストIP:PORTへアクセスがあったら、WSL2_IP:PORTに転送します。
        netsh interface portproxy add v4tov4 listenaddress=$HOST_IPV4 listenport=$port_num connectaddress=$WSL2_IPV4 connectport=$port_num
    }
}

# 確認コマンド
netsh interface portproxy show all