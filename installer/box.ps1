Disable-MicrosoftUpdate
Disable-UAC

#-----------#
# WinConfig #
#-----------#

# cf. https://boxstarter.org/WinConfig

# RDP 有効化
Enable-RemoteDesktop

# 拡張子表示
Set-WindowsExplorerOptions -EnableShowFileExtensions
# 隠しフォルダ表示
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives
# フォルダオプション「保護されたオペレーティング システム ファイルを表示しない（推奨）」
Set-WindowsExplorerOptions -EnableShowProtectedOSFiles

# リボン（上部メニュー内容）を常に表示
Set-WindowsExplorerOptions -EnableShowRibbon
# ナビゲーションウィンドウを「開いているフォルダーまで展開」しない
Set-WindowsExplorerOptions -DisableExpandToOpenFolder
# タイトルバーにフルパス表示
Set-WindowsExplorerOptions -EnableShowFullPathInTitleBar

# 「エクスプローラーで開く」を「クイックアクセス」から「PC」に
Set-WindowsExplorerOptions -DisableOpenFileExplorerToQuickAccess
# クイックアクセスに「最近使用したファイル」を非表示
Set-WindowsExplorerOptions -EnableShowRecentFilesInQuickAccess
# クイックアクセスの「よく使用するフォルダー」にピン留め以外も表示
Set-WindowsExplorerOptions -EnableShowFrequentFoldersInQuickAccess

#--------------#
# WSL/Terminal #
#--------------#

# Step 1. of https://docs.microsoft.com/ja-jp/windows/wsl/install-win10
cinst Microsoft-Windows-Subsystem-Linux -source windowsfeatures
# Step 3. of https://docs.microsoft.com/ja-jp/windows/wsl/install-win10
cinst VirtualMachinePlatform -source windowsfeatures

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Terminal Environment
cinst wsl

# for GUI when using ssh
[System.Environment]::SetEnvironmentVariable("DISPLAY", "localhost:0.0", "User")

# cf. https://netlog.jpn.org/r271-635/2021/08/windows10ver21h1_wsl2_inst.html
# cf. https://minettyo.com/entry/wsl_wsl2conversion

# WSL2 へ変更
wsl --set-default-version 2

#-----------------#
# Package Manager #
#-----------------#

# NuGet プロバイダー更新
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
# fzf wrapper (needs fzf binary from chocolatey or scoop)
Install-Module -Name PSFzf -RequiredVersion 2.1.0 -Scope CurrentUser -Force
# z コマンド
Install-Module -Name ZLocation -Scope CurrentUser -Force

# oh-my-posh integration for git prompt
Install-Module -Name posh-git -Scope CurrentUser -Force

Function winst {
   $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
   Invoke-Expression $cmd
}

# Avast
winst XPDNZJFNCR1B07
winst Google.Chrome
winst Google.JapaneseIME
winst 7zip.7zip
winst Adobe.Acrobat.Reader.32-bit

# Windows Terminal
winst 9N0DX20HK701
winst oh-my-posh
winst Canonical.Ubuntu.2004
winst marha.VcXsrv

# for the context menus
winget install Microsoft.VisualStudioCode --silent --accept-package-agreements --accept-source-agreements --override "/silent /mergetasks=""addcontextmenufiles,addcontextmenufolders"""
winst JetBrains.Toolbox
winst Git.Git

winst msys2.msys2
winst Kitware.CMake
winst EclipseAdoptium.Temurin.11

winst CondaForge.Miniforge3
New-Item -ItemType SymbolicLink -Path $env:UserProfile\anaconda3 -Target $env:UserProfile\miniforge3

winst QL-Win.QuickLook
winst voidtools.Everything
winst Ditto.Ditto
winst WinSCP.WinSCP
winst Microsoft.PowerToys
winst Piriform.Recuva

# Spotify from Microsoft Store
winst 9NCBCSZSJRSB
winst Apple.iTunes

# iCloud
winst 9PKTQ5699M62
winst Obsidian.Obsidian
winst Discord.Discord
winst Valve.Steam
winst Amazon.Kindle

winst Nvidia.GeForceExperience
winst SourceFoundry.HackFonts
winst Wacom.WacomTabletDriver

winst hadolint.hadolint
# $folderPath = "$env:LocalAppData\Microsoft\WinGet\Links"
# if (-not ($env:Path -split ';' | Select-String -SimpleMatch $folderPath)) {
#    $newPath = $env:Path + ";" + $folderPath
#    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
# }


cinst chocolateygui
cinst Keypirinha
cinst buffalo-nas-navigator
# cinst mo2 vortex

#-------------------#
# Development Tools #
#-------------------#

# Enable path to vscode command
refreshenv

# Install VSCode extensions
code --install-extension ms-ceintl.vscode-language-pack-ja
code --install-extension cocopon.iceberg-theme
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension eamodio.gitlens
code --install-extension coenraads.bracket-pair-colorizer-2
code --install-extension yzhang.markdown-all-in-one

git config --global init.defaultBranch main
git config --global core.editor vim
git config --global core.ignorecase false
git config --global core.quotepath false
git config --global ghq.root ~/src
git config --global gitflow.branch.master main
# for ssh push
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."https://".insteadOf git://

#-----------------#
# Recover Setting #
#-----------------#

Enable-UAC
Enable-MicrosoftUpdate
# Eula = End-User License Agreement
Install-WindowsUpdate -acceptEula
