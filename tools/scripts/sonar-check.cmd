@ECHO OFF

SETLOCAL

chcp 65001 > nul

echo START: %date% %time%

IF not defined SONAR_SCANNER (
    FOR /F "usebackq tokens=1 delims=" %%i IN (`where sonar-scanner`) DO (
        set SONAR_SCANNER=%%i
    )
)
IF not defined SONAR_SCANNER (
    set SONAR_SCANNER=C:\Program Files\sonar-scanner\bin\sonar-scanner.bat
)
IF not exist "%SONAR_SCANNER%" (
    echo [ERROR] Can't find "sonar-scanner" tool. Add path to "sonar-scanner.bat" to "PATH" environment variable, or set "SONAR_SCANNER" variable with full specified path 
    exit /b 1
)
set SONAR_SCANNER_OPTS=-Dfile.encoding=UTF-8 -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Xms2G -Xmx12G
set SONAR_USER_HOME=./.sonar

IF exist "%cd%\.env" (
    FOR /F "usebackq tokens=*" %%a in ("%cd%\.env") DO (
        FOR /F "tokens=1,* delims==" %%b IN ("%%a") DO (
            set "%%b=%%c"
        )
    )
)

chcp 65001

IF defined SONAR_SCANNER_DATE set SONAR_SCANNER_DATE_PARAM=-D"sonar.projectDate=%SONAR_SCANNER_DATE%"

call "%SONAR_SCANNER%" -D"sonar.host.url=%SONAR_HOST_URL%" -D"sonar.token=%SONAR_TOKEN%" %SONAR_SCANNER_DATE_PARAM% -D"project.settings=%cd%/sonar-project.properties"

echo FINISH: %date% %time%
