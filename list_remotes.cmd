
@ECHO OFF
CLS
SETLOCAL ENABLEDELAYEDEXPANSION
SET root_path=%~dp0
SET log_file=".\repos_remotes.json"

ECHO This script will loop through subdirs in current dir and log it's git remotes to %log_file% file.

ECHO Start working...
CHCP
PUSHD "%root_path%"
IF EXIST %log_file% ATTRIB -R -S -H -O %log_file%
ECHO ******************

ECHO {>%log_file%
ECHO.    "_datetime": "%DATE% %TIME%",>>%log_file%
@REM https://superuser.com/a/1464565, https://superuser.com/a/160712; DIR "." /AD-H /B
FOR /D %%a IN ("%root_path%*") DO FOR %%I IN ("%%a") DO (
    PUSHD "%%a"
    ECHO Working with: "%%~nxI"
    @REM https://stackoverflow.com/a/13805466
    FOR /F "tokens=*" %%i IN ('git config --get remote.origin.url') DO SET repo_remote=%%i
    ECHO.    "%%~nxI": "!repo_remote!",>>"..\%log_file%"
    IF "!repo_remote!" == "" (SET repo_remote=N/A) ELSE (SET repo_remote="!repo_remote!")
    ECHO.  Remote URL: !repo_remote!
    SET repo_remote=
    POPD
    @REM ToDo: git rev-parse --is-inside-work-tree (https://stackoverflow.com/a/16925062)
)
POPD
ECHO }>>%log_file%

ECHO ******************
ECHO Done working.

PAUSE
ENDLOCAL
EXIT /B %ERRORLEVEL%
