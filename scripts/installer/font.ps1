<#
  .SYNOPSIS
    Install fonts
  .DESCRIPTION
    https://stackoverflow.com/questions/16023238/installing-system-font-with-powershell
#>

# Ricty Diminished
if (-not ([System.String]::Join(" ", [System.Drawing.FontFamily]::Families)).Contains("Ricty Diminished for Powerline")) {
  $url = "https://github.com/mzyy94/RictyDiminished-for-Powerline/raw/master/powerline-fontpatched/Ricty%20Diminished%20Regular%20for%20Powerline.ttf"
  Invoke-WebRequest $url -OutFile $Home\RictyDiminished-for-Powerline.ttf
  
  # The CLSID of the special folder
  # cf. https://tarma.com/support/im9/using/symbols/functions/csidls.htm
  (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$Home\RictyDiminished-for-Powerline.ttf", 0x10)
  Remove-Item $Home\RictyDiminished-for-Powerline.ttf
}

# Cica
if (-not ([System.String]::Join(" ", [System.Drawing.FontFamily]::Families)).Contains("Cica")) {
  $url = "https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip"
  Invoke-WebRequest $url -OutFile $Home\Cica.zip
  Expand-Archive -Path $Home\Cica.zip -DestinationPath $Home\Cica
  
  # The CLSID of the special folder
  # cf. https://tarma.com/support/im9/using/symbols/functions/csidls.htm
  (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$Home\Cica\Cica-Regular.ttf", 0x10)
  Remove-Item $Home\Cica.zip
  Remove-Item -Recurse $Home\Cica
}
 