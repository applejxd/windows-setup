<#
  .SYNOPSIS
    Close ports for WSL2
  .DESCRIPTION
    Close all ports on Windows for SSH, RDP and HTTP to WSL2
#>

# ベースとするポート番号
$base_port_array = 50022, 53389, 58888
$port_name_array = "SSH", "RDP", "HTTP"
# まとまってポート開放する量
$range = 20

for ($port_index = 0; $port_index -lt $base_port_array.Count; $port_index++) {
    for ($shift_index = 0; $shift_index -lt $range; $shift_index++) {
        # 設定名
        $rule_name = "WSL-" + $port_name_array[$port_index] + "-" + [string]$shift_index
        # 設定が存在するか確認
        if (!(Get-NetFirewallRule -Name $rule_name -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
            # ルール削除    
            Remove-NetFireRule -DisplayName $rule_name
        }
    }
}

# 確認コマンド
netsh interface portproxy show all