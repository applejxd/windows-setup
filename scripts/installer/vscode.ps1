<#
  .SYNOPSIS
    Install VSCode and extentions
#>

# for the context menus
winget install Microsoft.VisualStudioCode --silent --accept-package-agreements --accept-source-agreements --override "/silent /mergetasks=""addcontextmenufiles,addcontextmenufolders"""
refreshenv

# Enable path to vscode command
# from https://stackoverflow.com/questions/17794507/reload-the-path-in-powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 

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
