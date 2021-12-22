@echo off

set v8version=8.3.17.2256
set v8path="C:\Program Files\1cv8\%v8version%\bin\1cv8"
set edtprojectpath=%cd%\dp
set tmpdir=%cd%\tmp
set tmpib="%tmpdir%\buildext"
set buildpath=%edtprojectpath%\bin

md "%tmpdir%"
md "%tmpdir%\ws"
md "%tmpdir%\result"

echo Starting export to 1C:Designer XML format...

call ring edt workspace export --project "%edtprojectpath%" --configuration-files "%tmpdir%\result" --workspace-location "%tmpdir%\ws"

echo Starting build external data processors ^& reports...

echo Creating temporary infobase %tmpib%

%v8path% CREATEINFOBASE /F%tmpib% /DisableStartupDialogs

FOR /f %%f IN ('dir /b /a-d "%tmpdir%\result\ExternalDataProcessors\*.xml"') DO (
    FOR %%i IN (%%~nf) DO (
        echo Building %%~ni...
        %v8path% DESIGNER /F%tmpib% /LoadExternalDataProcessorOrReportFromFiles "%tmpdir%\result\ExternalDataProcessors\%%~ni.xml" "%buildpath%" /DisableStartupDialogs
    )
)

rmdir /S /Q "%tmpdir%"

echo Finish building external data processors ^& reports.
