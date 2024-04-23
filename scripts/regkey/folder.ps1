<#
  .SYNOPSIS
    set folder options
#>

$reg_root = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"

# 拡張子表示
Set-ItemProperty "$reg_root\Advanced" -name "HideFileExt" -Value 0
# 隠しフォルダ表示
Set-ItemProperty "$reg_root\Advanced" -name "Hidden" -Value 1
# タイトルバーにフルパス表示
Set-ItemProperty "$reg_root\CabinetState" -name "FullPath" -Value 1
# 「エクスプローラーで開く」を「クイックアクセス」から「PC」に
Set-ItemProperty "$reg_root\Advanced" -name "LaunchTo" -Value 1
