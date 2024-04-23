<#
  .SYNOPSIS
    decompress files by double-click using 7-Zip
  .DESCRIPTION
    [Attension!] set registry keys
#>

# make HKEY_CLASSES_ROOT editable
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

$exts = @("7z", "zip", "rar", "lzh", "tar", "gz")
foreach ($ext in $exts) {
    Set-ItemProperty -Path "HKCR:\7-Zip.$ext\shell\open\command" -Name "(default)" -Value "`"C:\Program Files\7-Zip\7zG.exe`" x `"%1`" -o*"
}