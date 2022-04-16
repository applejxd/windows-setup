# cf. https://qiita.com/yabeenico/items/15532c703974dc40a7f5

# 設定パラメータ
$base_port_array = 50022, 53389, 58888
$port_name_array = "SSH", "RDP", "HTTP"
$range=20

# IP アドレス取得
$wsl_ip=(wsl --exec hostname -I | awk '{print $1}')

for ($port_index=0; $port_index -lt $base_port_array.Count; $port_index++){
    for ($shift_index=0; $shift_index -lt $range; $shift_index++){
        $port_num = $base_port_array[$port_index] + $shift_index
        # 古いポートフォワード設定を削除
        netsh interface portproxy delete v4tov4 listenport=$port_num
        # ポートフォワード設定
        netsh interface portproxy add v4tov4 listenport=$port_num connectaddress=$wsl_ip connectport=$port_num

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
