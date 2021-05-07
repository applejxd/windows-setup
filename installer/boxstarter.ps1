Disable-MicrosoftUpdate
Disable-UAC

#####################
# Explorer settings #
#####################

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

##############
# Chocolatey #
##############

cinst chocolateygui
cinst 7zip
choco install git.install --params "/GitAndUnixToolsOnPath"

cinst GoogleChrome
cinst GoogleJapaneseInput
cinst google-backup-and-sync
cinst avastfreeantivirus
cinst baffalo-nas-navigator

cinst Keyhac
cinst Keypirinha
cinst Everything
cinst QuickLook
cinst ditto
cinst WinSCP
cinst InkScape

cinst iTunes
cinst kindle
cinst geforce-game-ready-driver
cinst steam
cinst discord
cinst mo2
# cinst vortex

################
# WSL/Terminal #
################

# Step 1. of https://docs.microsoft.com/ja-jp/windows/wsl/install-win10
cinst Microsoft-Windows-Subsystem-Linux -source windowsfeatures
# Step 3. of https://docs.microsoft.com/ja-jp/windows/wsl/install-win10
cinst VirtualMachinePlatform -source windowsfeatures

# Terminal Environment
cinst wsl
cinst vcxsrv
cinst microsoft-windows-terminal
cinst hackfont
cinst cascadia-code-nerd-font

#####################
# Development Tools #
#####################

# Development environments
cinst Cygwin
cinst anaconda3

# JetBrains toolbox -> Install IDEs manually
cinst jetbrainstoolbox

cinst vscode
# Enable path to vscode command
refreshenv
# Install VSCode extensions
code --install-extension ms-ceintl.vscode-language-pack-ja
code --install-extension cocopon.iceberg-theme
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension eamodio.gitlens
code --install-extension coenraads.bracket-pair-colorizer-2
code --install-extension yzhang.markdown-all-in-one

Enable-UAC
Enable-MicrosoftUpdate
# Eula = End-User License Agreement
Install-WindowsUpdate -acceptEula
