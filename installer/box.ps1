<#
  .SYNOPSIS
    Boxstarter scirpt
  .DESCRIPTION
    Use winget and chocolatey
    [Attention!] Includes security configurations
#>

# Disable-MicrosoftUpdate
# Disable-UAC

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

# TODO: need to be updated
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

winst Google.Chrome
winst Google.JapaneseIME
winst 7zip.7zip

winst oh-my-posh
winst Canonical.Ubuntu.2004

winst QL-Win.QuickLook
winst voidtools.Everything
winst Ditto.Ditto
winst WinSCP.WinSCP
winst Microsoft.PowerToys
winst SourceFoundry.HackFonts

cinst chocolateygui
cinst Keypirinha

#-----#
# Git #
#-----#

winst Git.Git
git config --global init.defaultBranch main
git config --global core.editor vim
git config --global core.ignorecase false
git config --global core.quotepath false
git config --global ghq.root ~/src
git config --global gitflow.branch.master main
# for ssh push
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."https://".insteadOf git://

#--------#
# VSCode #
#--------#

# for the context menus
winget install Microsoft.VisualStudioCode --silent --accept-package-agreements --accept-source-agreements --override "/silent /mergetasks=""addcontextmenufiles,addcontextmenufolders"""

# Enable path to vscode command
refreshenv

# Theme
code --install-extension ms-ceintl.vscode-language-pack-ja
code --install-extension Anan.jetbrains-darcula-theme
code --install-extension chadalen.vscode-jetbrains-icon-theme
code --install-extension usernamehw.errorlens

# Git
code --install-extension eamodio.gitlens
code --install-extension mhutchie.git-graph

# Markdown
code --install-extension yzhang.markdown-all-in-one
code --install-extension DavidAnson.vscode-markdownlint

# Remote
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode-remote.remote-containers

# C/C++
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension ms-vscode.cpptools-themes
code --install-extension xaver.clang-format
code --install-extension jeff-hykin.better-cpp-syntax
code --install-extension notskm.clang-tidy
code --install-extension twxs.cmake
code --install-extension ms-vscode.cmake-tools

# Python
code --install-extension ms-python.python
code --install-extension ms-python.isort
code --install-extension ms-python.black-formatter

#-----------#
# Dev tools #
#-----------#

winst Nvidia.GeForceExperience

# Docker
winst hadolint.hadolint
winst Docker.DockerDesktop

# C++
winst Microsoft.VisualStudio.2022.Community
winst Kitware.CMake

# Python
winst Python.Python.3.9
winst Python.Python.3.10
winst Python.Python.3.11
winst Python.Python.3.12

#-----------------#
# Recover Setting #
#-----------------#

# Enable-UAC
# Enable-MicrosoftUpdate
# # Eula = End-User License Agreement
# Install-WindowsUpdate -acceptEula
