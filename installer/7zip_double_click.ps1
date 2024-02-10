# 7-Zip でダブルクリックで解凍できるように

# HKEY_CLASSES_ROOT を編集可能に
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

$exts = @("7z", "zip", "rar", "lzh", "tar", "gz")
foreach ($ext in $exts) {
    Set-ItemProperty -Path "HKCR:\7-Zip.$ext\shell\open\command" -Name "(default)" -Value "`"C:\Program Files\7-Zip\7zG.exe`" x `"%1`" -o*"
}