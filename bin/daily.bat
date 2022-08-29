@echo off

set year=%date:~0,4%
set month=%date:~5,2%
set day=%date:~8,2%

set template_file=%USERPROFILE%\src\windows-setup\bin\daily.md
set root_path=%USERPROFILE%\markdown
set save_path=%root_path%\daily\%year%\%month%
set file_path=%save_path%\%date:/=-%.md

if not exist %save_path% mkdir %save_path%
if not exist %file_path% copy %template_file% %file_path%

code %folder_path% %file_path%
