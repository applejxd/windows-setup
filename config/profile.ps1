# エンコーディングを US-ASCII から変更
# cf. https://dattesar.com/powershell-utf8/
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# cf. https://secon.dev/entry/2020/08/17/070735/

# テーマ
# OneDrive の MyDocuments 同期は非推奨（パスが変更されるため）
# cf. https://ohmyposh.dev/docs/installation/customize
oh-my-posh init pwsh --config $env:POSH_THEMES_PATH/pure.omp.json | Invoke-Expression

# キーバインド
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
# 標準だと Ctrl+d は DeleteCharOrExit のため、うっかり端末が終了することを防ぐ
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

#########
# alias #
#########

Set-Alias open explorer.exe
Set-Alias pbcopy clip.exe
Set-Alias pbpaste Get-Clipboard
function relogin { powershell $Profile.CurrentUserAllHosts }

#######
# fzf #
#######
#cf. https://github.com/junegunn/fzf/wiki/Windows

$env:FZF_DEFAULT_OPTS = "--reverse --border"

# C-t と C-r のラッパー
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# ghq-fzf
# C-x C-g のキーバインドに関数割り当て
if (Get-Command ghq -ea SilentlyContinue) {
  Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+g' -ScriptBlock {
    $path = ghq list | fzf
    # パスが空の文字列でなければ実行
    if (!([string]::IsNullOrEmpty($path))) {
      Set-Location "$(ghq root)\$path"
      # バッファの内容を実行
      [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
    # 画面をクリア
    Clear-Host
  }
}

# z-fzf
Import-Module ZLocation
if (Get-Command z -ea SilentlyContinue) {
  Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+f' -ScriptBlock {
    # ZLocation の一覧オブジェクトの Path プロパティ抜き出し
    $path = z -l | ForEach-Object { Write-Output $_.Path } | fzf
    if (!([string]::IsNullOrEmpty($path))) {
      Set-Location "$path"
      [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
    Clear-Host
  }
}

function fssh {
  $destination = Get-Content "$HOME/.ssh/config" | Select-String "^Host ([^*]+)$" | ForEach-Object { $_ -replace "Host ", "" } | fzf
  if (!([string]::IsNullOrEmpty($destination))) { 
    ssh "$destination"
  }
  Clear-Host
}

############
# Anaconda #
############

function condals { conda env list }

function condarun {
  $env_name = (conda env list | Select-Object -Skip 2 | Select-Object -SkipLast 1 | fzf).Split(" ")[0]
  if (![string]::IsNullOrEmpty($env_name)) {
    conda activate "$env_name"
  }
}

function condarm {
  $env_name = (conda env list | Select-Object -Skip 2 | Select-Object -SkipLast 1 | fzf).Split(" ")[0]
  if (![string]::IsNullOrEmpty($env_name)) {
    conda env remove -n "$env_name"
  }
}


#######
# WSL #
#######

function wslls { wsl -l -v }

function wslex {
  # Where-Object で空行削除
  $distro = wsl -l -q | Where-Object { $_ -ne "" } | fzf
  if (!([string]::IsNullOrEmpty($distro))) {
    # null 文字を削除
    # cf. https://stackoverflow.com/questions/9863455/how-to-remove-null-char-0x00-from-object-within-powershell
    $distro = $distro -replace "`0", ""
    $date = Get-Date -UFormat "%y.%m.%d"
    # https://sevenb.jp/wordpress/ura/2016/06/01/powershell%E6%96%87%E5%AD%97%E5%88%97%E5%86%85%E3%81%AE%E5%A4%89%E6%95%B0%E5%B1%95%E9%96%8B%E3%81%A7%E5%A4%89%E6%95%B0%E5%90%8D%E3%82%92%E7%A2%BA%E5%AE%9A%E3%81%95%E3%81%9B%E3%82%8B/
    wsl --export "${distro}" "${distro}_${date}.tar"
  }
  Clear-Host
}

function wslim {
  $file_name = Get-ChildItem ./*.tar -name | fzf
  $distro_name = [System.IO.Path]::GetFileNameWithoutExtension($file_name)
  $import_path = [Environment]::GetFolderPath('LocalApplicationData') + "\WSL"
  if (!(Test-Path $import_path)) {
    mkdir $import_path
  }
  wsl --import $distro_name "${import_path}\${distro_name}" $file_name
}

function wslrm {
  # Where-Object で空行削除
  $distro = wsl -l -q | Where-Object { $_ -ne "" } | fzf
  if (!([string]::IsNullOrEmpty($distro))) {
    # null 文字を削除
    # cf. https://stackoverflow.com/questions/9863455/how-to-remove-null-char-0x00-from-object-within-powershell
    $distro = $distro -replace "`0", ""
    wsl --unregister $distro
  }
  Clear-Host
}

function wslin {
  # Where-Object で空行削除
  $distro = wsl -l --online | Where-Object { $_ -ne "" } | Select-Object -Skip 3 | fzf
  if (!([string]::IsNullOrEmpty($distro))) {
    # null 文字を削除 & スペース区切りで最初の文字列取得
    # cf. https://stackoverflow.com/questions/9863455/how-to-remove-null-char-0x00-from-object-within-powershell
    $distro = ($distro -replace "`0", "").Split(" ")[0]
    wsl --install -d $distro
  }
  Clear-Host
}

function wslrun {
  # Where-Object で空行削除
  $distro = wsl -l -q | Where-Object { $_ -ne "" } | fzf
  if (!([string]::IsNullOrEmpty($distro))) {
    # null 文字を削除
    # cf. https://stackoverflow.com/questions/9863455/how-to-remove-null-char-0x00-from-object-within-powershell
    $distro = $distro -replace "`0", ""
    wsl ~ -d $distro $args -e /usr/bin/bash
  }
  Clear-Host
}

function wsluser ($distro, $user) { 
  Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | `
  Where-Object -Property DistributionName -eq $distro | `
  Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String)
}

#######
# WSL #
#######

function dls { docker ps -a }

function dim { docker images }

function drun {
  $selected_line = docker images | Select-Object -Skip 1 | fzf
  # null 文字を削除 & 空白区切り & 空の要素を削除
  $image_info=($selected_line -replace "`0", "").Split(" ") -ne ""
  $image=$image_info[0] + ":" + $image_info[1]
  if (!([string]::IsNullOrEmpty($image))) {
    docker run -it --rm --gpus all "$image"
  }
}

function drmi {
  $selected_line = docker images | Select-Object -Skip 1 | fzf
  # null 文字を削除 & 空白区切り & 空の要素を削除
  $image_info=($selected_line -replace "`0", "").Split(" ") -ne ""
  if (!([string]::IsNullOrEmpty($image_info))) {
    docker rmi $image_info[2]
  }
}

function dsh {
  $cid=(docker ps -a | Select-Object -Skip 1 | fzf).Split(" ")[0]
  if (!([string]::IsNullOrEmpty($cid))) {
    docker exec -it "$cid" /bin/bash
  }
}

function da {
  $cid=(docker ps -a | Select-Object -Skip 1 | fzf).Split(" ")[0]
  if (!([string]::IsNullOrEmpty($cid))) {
    docker start "$cid"
    docker attach "$cid"
  }
}

function ds {
  $cid=(docker ps -a | Select-Object -Skip 1 | fzf).Split(" ")[0]
  if (!([string]::IsNullOrEmpty($cid))) {
    docker stop "$cid"
  }
}

function drm {
  $cid=(docker ps -a | Select-Object -Skip 1 | fzf).Split(" ")[0]
  if (!([string]::IsNullOrEmpty($cid))) {
    docker rm "$cid"
  }
}

function dbuild() {
  $file_name=$(Get-ChildItem -Recurse -Name -File *.dockerfile | fzf)
  $date_tag=$(Get-Date -Format "yyyy.MM.dd")
  $cname="local/"+$file_name.Split(".")[0]+":"+"$date_tag"
  if (!([string]::IsNullOrEmpty($cname))) {
    docker build -t "$cname" -f "$file_name" .
  }
}

function dcom() {
  $file_name=$(Get-ChildItem -Recurse -Name -File *.yml | fzf)
  if (!([string]::IsNullOrEmpty($fine_name))) {
    docker-compose -f "$file_name" up -d
  }
}
