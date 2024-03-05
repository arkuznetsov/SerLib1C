@ECHO OFF

set REPO_PATH=%cd%
set SRC_PATH=%REPO_PATH%\dp
set DST_PATH=%REPO_PATH%\dp\bin
set V8_TEMP=%REPO_PATH%\tmp

set SCRIPT_PATH=%REPO_PATH%\tools\1CFilesConverter\scripts

echo Starting build external data processors ^& reports...

call %SCRIPT_PATH%\dp2epf.cmd "%SRC_PATH%" "%DST_PATH%"

echo Finish build external data processors ^& reports.
