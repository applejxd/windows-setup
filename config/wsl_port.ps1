# cf. https://qiita.com/yabeenico/items/15532c703974dc40a7f5

# IP アドレス取得
$IP=(wsl --exec hostname -I | awk '{print $1}')
$PORT=22000

# 古いポートフォワード設定を削除
netsh interface portproxy delete v4tov4 listenport=$PORT
# ポートフォワード設定
netsh interface portproxy add v4tov4 listenport=$PORT connectaddress=$IP connectport=2222

# 確認コマンド
# netsh interface portproxy show all

# ポート開放
if (!(Get-NetFirewallRule -Name "WSL-SSH" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    New-NetFirewallRule -Name 'WSL-SSH' -DisplayName 'sshd in WSL' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $PORT
}