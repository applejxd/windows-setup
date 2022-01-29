# cf. https://qiita.com/yabeenico/items/15532c703974dc40a7f5

$IP=(wsl --exec hostname -I | awk '{print $1}')
$PORT=22000

# 古い設定を削除
netsh interface portproxy delete v4tov4 listenport=$PORT
# ホストIP:PORTへアクセスがあったら、WSL2_IP:PORTに転送します。
netsh interface portproxy add v4tov4 listenport=$PORT connectaddress=$IP connectport=2222

# 確認コマンド
# netsh interface portproxy show all

if (!(Get-NetFirewallRule -Name "WSL-SSH" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    New-NetFirewallRule -Name 'WSL-SSH' -DisplayName 'sshd in WSL' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $PORT
}