@echo off
: ファイルへの D&D で対象ファイル/フォルダのシンボリックリンクを生成

:カレントディレクトリを設定する
cd /d %~dp0

:シンボリックリンクを生成するためのbatファイルを作成する
echo cd /d %~dp0 > temp.bat
echo mklink /d %~n1 %1 >>temp.bat

:管理者権限作成したbatを実行する( mklinkの実行には管理者権限がいる )
powershell start-process temp.bat -verb runas

:作成したbatファイルを削除する
timeout 1
del temp.bat