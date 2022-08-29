set year=%date:~0,4%
set month=%date:~5,2%
set day=%date:~8,2%

set file_name=%year%-%month%-%day%
copy %USERPROFILE%\src\windows-setup\bin\daily.md %USERPROFILE%\markdown\daily\%file_name%.md
code %USERPROFILE%\markdown\daily\%file_name%.md
