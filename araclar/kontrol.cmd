@echo off
chcp 65001 >nul
set SRC=%~dp0..\app
set DST=C:\Users\erene\dev\mevo_insa\app
robocopy "%SRC%" "%DST%" /MIR /XD build .dart_tool .gradle .kotlin /XF key.properties local.properties /NFL /NDL /NJH /NJS /NP
cd /d %DST%
echo === ANALYZE
call flutter analyze
echo === TEST
call flutter test %*
copy /y build\ses_ornek_*.txt "%~dp0" >nul
echo === BITTI
