@echo off

set v8version=8.3.14.1779
set v8path="C:\Program Files\1cv8\%v8version%\bin\1cv8"
set edtprojectpath=%cd%\dp
set tmpdir=%cd%\tmp
set buildpath=%edtprojectpath%\bin

md "%tmpdir%"
md "%tmpdir%\ws"
md "%tmpdir%\result"

echo Starting export to 1C:Designer XML format...

call ring edt workspace export --project "%edtprojectpath%" --configuration-files "%tmpdir%\result" --workspace-location "%tmpdir%\ws"

echo Starting build external data processors ^& reports...

FOR /f %%f IN ('dir /b /a-d "%tmpdir%\result\ExternalDataProcessors\*.xml"') DO (
    FOR %%i IN (%%~nf) DO (
        echo Building %%~ni...
        %v8path% DESIGNER /LoadExternalDataProcessorOrReportFromFiles "%tmpdir%\result\ExternalDataProcessors\%%~ni.xml" "%buildpath%"
    )
)

rm -fr "%tmpdir%"

echo Finish building external data processors ^& reports.
