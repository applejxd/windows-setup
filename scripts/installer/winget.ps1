<#
  .SYNOPSIS
    Install packages by winget and NuGet
  .DESCRIPTION
    Install keypirinha via chocolatey
#>

# ----- #
# NuGet #
# ----- #

# NuGet プロバイダー更新
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
# fzf wrapper (needs fzf binary from chocolatey or scoop)
Install-Module -Name PSFzf -RequiredVersion 2.1.0 -Scope CurrentUser -Force
# z コマンド
Install-Module -Name ZLocation -Scope CurrentUser -Force

# oh-my-posh integration for git prompt
Install-Module -Name posh-git -Scope CurrentUser -Force

# ------ #
# winget #
# ------ #

Function winst {
  $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
  Invoke-Expression $cmd
}

# tools
winst Google.Chrome
winst Google.JapaneseIME
winst 7zip.7zip

# terminal
winst oh-my-posh
winst SourceFoundry.HackFonts

# utilities
winst Microsoft.PowerToys
winst QL-Win.QuickLook
winst voidtools.Everything
winst Ditto.Ditto
winst WinSCP.WinSCP
