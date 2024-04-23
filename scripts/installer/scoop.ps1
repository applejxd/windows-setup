<#
  .SYNOPSIS
    Install packages by scoop
  .DESCRIPTION
    Install Linux tools to user environments by scoop
#>

# Memo: Japanese comments cause new line error

if (!(Get-Command scoop -ea SilentlyContinue)) {
  Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}

# Linux commands (gow = Gnu on Windows)
# cf. https://github.com/bmatzelle/gow/wiki/executables_list
scoop install sudo gow

# build tools
scoop install mingw-winlibs
# other tools
scoop install ghq fzf pdftk
