# Make TaskScheduler for WSL2 portforwarding
# cf. https://zenn.dev/fate_shelled/scraps/f6252654277ca0
# cf. https://syanaise-soudan.com/scheduledtask-powershell/

$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -Argument "-ExecutionPolicy RemoteSigned $env:UserProfile\src\windows-setup\config\wsl2_port.ps1"

Register-ScheduledTask -TaskName "WSL2 Port Forwarding" -Action $Action -Trigger $Trigger -RunLevel Highest -Force