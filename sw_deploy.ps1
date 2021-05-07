# 特殊フォルダのパス取得のために Shell オブジェクトの生成
$wsh = New-Object -ComObject WScript.Shell

####################
# 設定ファイルリンク #
####################

# リポジトリのクローン
$install_path = "$env:UserProfile\src\windows-setup"
if (-not (Test-Path $install_path)){
  git clone https://github.com/applejxd/windows-setup.git $install_path
}

# Keyhac
cmd /c rmdir /s /q $env:AppData\Keyhac
cmd /c mklink /D $env:AppData\Keyhac $env:UserProfile\src\windows-setup\tools\Keyhac
$install_path = "$env:AppData\Keyhac\extension\fakeymacs"
if (-not (Test-Path $install_path)){
  git clone https://github.com/smzht/fakeymacs.git $install_path
}

# Keypirinha
cmd /c rmdir /s /q $env:AppData\Keypirinha
cmd /c mklink /D $env:AppData\Keypirinha $env:UserProfile\src\windows-setup\tools\Keypirinha

# Everything
cmd /c rmdir /s /q $env:AppData\Everything
cmd /c mklink /D $env:AppData\Everything $env:UserProfile\src\windows-setup\tools\Everything

####################
# スタートアップ登録 #
####################

# ショートカット名を定義
$path = $wsh.SpecialFolders("Startup") + "\keyhac.lnk"

if (-not (Test-Path $path)){
  # ショートカットオブジェクトの生成
  $shortcut = $wsh.CreateShortcut($path)

  # 作業ディレクトリのパスを設定
  $shortcut.WorkingDirectory = "C:\ProgramData\chocolatey\bin"
  # ショートカット先のパスを設定
  $shortcut.TargetPath = "C:\ProgramData\chocolatey\bin\keyhac.exe"
  # アイコンのパスを設定
  $shortcut.IconLocation = "C:\ProgramData\chocolatey\bin\keyhac.exe"

  # ショートカットの生成
  $shortcut.Save()
}

###################
# Keypirinha 拡張 #
###################

# インストールディレクトリ
$install_dir = "$env:UserProfile\src\windows-setup\tools\Keypirinha\InstalledPackages"
if (-not (Test-Path $install_dir)){
  New-Item $install_dir -ItemType Directory
}

# 各 Keypirinha 拡張をダウンロードする関数
function InstallRelease($repo_name, $file_name) {
  $install_dir = "$env:UserProfile\src\windows-setup\tools\Keypirinha\InstalledPackages"
  if (-not (Test-Path $install_dir\$file_name)){
    # GitHub Release API
    $uri = "https://api.github.com/repos/" + $repo_name + "/releases/latest"
    # Read json
    $json = Invoke-WebRequest $uri | ConvertFrom-Json
    # Get URL
    $url = $json.assets.browser_download_url
    # Download
    Invoke-WebRequest $url -OutFile "$install_dir\$file_name"
  }
}

InstallRelease "Fuhrmann/keypirinha-url-shortener" "URLShortener.keypirinha-package"
InstallRelease "psistorm/keypirinha-systemcommands" "SystemCommands.keypirinha-package"
InstallRelease "clinden/keypirinha-colorpicker" "ColorPicker.keypirinha-package"
InstallRelease "dozius/keypirinha-snippets" "Snippets.keypirinha-package"
# Clipborad Manager
InstallRelease "tuteken/Keypirinha-Plugin-Ditto" "Ditto.keypirinha-package"
# Default Windows Apps
InstallRelease "ueffel/Keypirinha-WindowsApps" "WindowsApps.keypirinha-package"
# Windows Terminal Profiles
InstallRelease "fran-f/keypirinha-terminal-profiles" "Terminal-Profiles.keypirinha-package"
# Search by abbrev
InstallRelease "bantya/Keypirinha-EasySearch" "EasySearch.keypirinha-package"
# Execute commands from >
InstallRelease "bantya/Keypirinha-Command" "Command.keypirinha-package"

Invoke-WebRequest "https://github.com/EhsanKia/keypirinha-plugins/raw/master/keypirinha-steam/build/Steam.keypirinha-package" -OutFile "$install_dir/Steam.keypirinha-package"
