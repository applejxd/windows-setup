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
# Define extension categories
$extensions = @{
  "Theme"      = @(
      "ms-ceintl.vscode-language-pack-ja",
      "Anan.jetbrains-darcula-theme",
      "chadalen.vscode-jetbrains-icon-theme",
      "usernamehw.errorlens"
  )
  "Git"        = @(
      "eamodio.gitlens",
      "mhutchie.git-graph"
  )
  "Remote"     = @(
      "ms-vscode-remote.remote-wsl",
      "ms-vscode-remote.remote-containers"
  )
  "AI agent"   = @(
      "genieai.chatgpt-vscode",
      "saoudrizwan.claude-dev"
  )
  "Markdown"   = @(
      "yzhang.markdown-all-in-one",
      "DavidAnson.vscode-markdownlint"
  )
  "C/C++"      = @(
      "ms-vscode.cpptools",
      "ms-vscode.cpptools-extension-pack",
      "ms-vscode.cpptools-themes",
      "xaver.clang-format",
      "jeff-hykin.better-cpp-syntax",
      "notskm.clang-tidy",
      "twxs.cmake",
      "ms-vscode.cmake-tools"
  )
  "Python"     = @(
      "ms-python.python",
      "ms-python.isort",
      "ms-python.black-formatter"
  )
}

# Install all extensions
foreach ($category in $extensions.Keys) {
  foreach ($extension in $extensions[$category]) {
      code --install-extension $extension
  }
}
