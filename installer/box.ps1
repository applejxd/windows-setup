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

# wsl --list --verbose
# wsl --install -d Ubuntu-20.04
# wsl --update

# WSL2 へ変更
# wsl --set-version Ubuntu-20.04 2
# wsl --set-default-version2

# バージョン確認
# wsl --status

#-----------------#
# Package Manager #
#-----------------#

# NuGet プロバイダー更新
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
# fzf wrapper
Install-Module -Name PSFzf -RequiredVersion 2.1.0 -Scope CurrentUser -Force
# z コマンド
Install-Module ZLocation -Scope CurrentUser -Force

# oh-my-posh v2 for PowerShell v5.1
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force

Function winst {
    winget install --silent --accept-package-agreements --accept-source-agreements $args
}

cinst avastfreeantivirus
winst Google.Chrome
winst Google.JapaneseIME
winst 7zip.7zip
winst Adobe.Acrobat.Reader.32-bit

winst Microsoft.WindowsTerminal
winst Canonical.Ubuntu.2004
winst marha.VcXsrv

winst Microsoft.VisualStudioCode
winst JetBrains.Toolbox
winst Git.Git

winst msys2.msys2
winst Kitware.CMake
winst CondaForge.Miniforge3
winst EclipseAdoptium.Temurin.11

winst QL-Win.QuickLook
winst voidtools.Everything
winst Ditto.Ditto
winst WinSCP.WinSCP
winst Microsoft.PowerToys
winst Piriform.Recuva

winst Spotify.Spotify
winst Apple.iTunes

winst Discord.Discord
winst Valve.Steam
winst Amazon.Kindle

winst Nvidia.GeForceExperience
winst SourceFoundry.HackFonts

cinst chocolateygui

cinst Keyhac 
cinst Keypirinha

cinst cascadia-code-nerd-font

cinst buffalo-nas-navigator
# cinst mo2 vortex

# Scoop のインストール
if(!(Get-Command scoop -ea SilentlyContinue)) {
    Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}
scoop install sudo vim ghq fzf which sed gawk pdftk

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
git config --global url."git@github.com:".PushInsteadOf https://github.com/

ghq get https://github.com/applejxd/windows-setup.git

#------#
# Font #
#------#

# cf. https://stackoverflow.com/questions/16023238/installing-system-font-with-powershell

# The CLSID of the special folder
# cf. https://tarma.com/support/im9/using/symbols/functions/csidls.htm
Invoke-WebRequest https://github.com/mzyy94/RictyDiminished-for-Powerline/raw/master/powerline-fontpatched/Ricty%20Diminished%20Regular%20for%20Powerline.ttf -OutFile $Home\RictyDiminished-for-Powerline.ttf
(New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$Home\RictyDiminished-for-Powerline.ttf", 0x10)
Remove-Item $Home\RictyDiminished-for-Powerline.ttf

#-----------------#
# Recover Setting #
#-----------------#

Enable-UAC
Enable-MicrosoftUpdate
# Eula = End-User License Agreement
Install-WindowsUpdate -acceptEula
