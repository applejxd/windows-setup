#########
# NuGet #
#########

# NuGet プロバイダー更新
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
# fzf wrapper
Install-Module -Name PSFzf -RequiredVersion 2.1.0 -Scope CurrentUser -Force
# z コマンド
Install-Module ZLocation -Scope CurrentUser -Force

# oh-my-posh v2 for PowerShell v5.1
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force

########
# Font #
########

# cf. https://stackoverflow.com/questions/16023238/installing-system-font-with-powershell

# The CLSID of the special folder
# cf. https://tarma.com/support/im9/using/symbols/functions/csidls.htm
Invoke-WebRequest https://github.com/mzyy94/RictyDiminished-for-Powerline/raw/master/powerline-fontpatched/Ricty%20Diminished%20Regular%20for%20Powerline.ttf -OutFile $Home\RictyDiminished-for-Powerline.ttf
(New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("$Home\RictyDiminished-for-Powerline.ttf", 0x10)
Remove-Item $Home\RictyDiminished-for-Powerline.ttf

###################
# Package Manager #
###################

winget import -i "$env:USERPROFILE\src\windows-setup\installer\winget.json"  --accept-package-agreements --accept-source-agreements

# Chocolatey のインストール
if(!(Get-Command choco -ea SilentlyContinue)) {
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
cinst -y "$env:USERPROFILE\src\windows-setup\installer\choco.config"

# Scoop のインストール
if(!(Get-Command scoop -ea SilentlyContinue)) {
  Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}
scoop install sudo vim ghq fzf which sed gawk
# git config --global ghq.root ~/src

# Install boxstarter (and chocolatey simultaneously)
. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/applejxd/windows-setup/main/installer/box.ps1" -DisableReboots

#######
# WSL #
#######

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

#######
# Git #
#######

git config --global init.defaultBranch main

git config --global core.editor vim
git config --global core.ignorecase false
git config --global core.quotepath false

git config --global ghq.root ~/src

git config --global gitflow.branch.master main

# for ssh push
git config --global url."git@github.com:".PushInsteadOf https://github.com/

##########
# VSCode #
##########

# Install VSCode extensions
code --install-extension ms-ceintl.vscode-language-pack-ja
code --install-extension cocopon.iceberg-theme
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension eamodio.gitlens
code --install-extension coenraads.bracket-pair-colorizer-2
code --install-extension yzhang.markdown-all-in-one
