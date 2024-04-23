<#
  .SYNOPSIS
    Install development tools
#>

Function winst {
    $cmd = "winget install --silent --accept-package-agreements --accept-source-agreements $args"
    Invoke-Expression $cmd
}


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

#-------#
# Tools #
#-------#

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
