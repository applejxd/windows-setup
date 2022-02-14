# cf. https://qiita.com/yabeenico/items/15532c703974dc40a7f5

# IP アドレス取得
$IP=(wsl --exec hostname -I | awk '{print $1}')
$SSH_PORT=22000
$RDP_PORT=33890

# 古いポートフォワード設定を削除
netsh interface portproxy delete v4tov4 listenport=$SSH_PORT
netsh interface portproxy delete v4tov4 listenport=$RDP_PORT

# ポートフォワード設定
netsh interface portproxy add v4tov4 listenport=$SSH_PORT connectaddress=$IP connectport=2222
netsh interface portproxy add v4tov4 listenport=$RDP_PORT connectaddress=$IP connectport=3390

# 確認コマンド
# netsh interface portproxy show all

# ポート開放
if (!(Get-NetFirewallRule -Name "WSL-SSH" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    New-NetFirewallRule -Name 'WSL-SSH' -DisplayName 'sshd in WSL' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $SSH_PORT
}
if (!(Get-NetFirewallRule -Name "WSL-RDP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    New-NetFirewallRule -Name 'WSL-RDP' -DisplayName 'xrdp in WSL' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $RDP_PORT
}