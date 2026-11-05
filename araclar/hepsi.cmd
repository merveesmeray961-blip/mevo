@echo off
chcp 65001 >nul
call "%~dp0kontrol.cmd" > C:\Users\erene\dev\mevo_insa\kontrol.log 2>&1
call "%~dp0derle.cmd" > C:\Users\erene\dev\mevo_insa\derle.log 2>&1
cd /d C:\Users\erene\dev\mevo_insa\app
call flutter test tool/magaza_gorsel_test.dart --update-goldens > C:\Users\erene\dev\mevo_insa\golden.log 2>&1
robocopy C:\Users\erene\dev\mevo_insa\app\tool\goldens "%~dp0..\app\tool\goldens" /E /NFL /NDL /NJH /NJS /NP >nul
echo BITTI >> C:\Users\erene\dev\mevo_insa\golden.log
