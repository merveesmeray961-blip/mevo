@echo off
chcp 65001 >nul
call C:\Users\erene\dev\mevo_insa\k.cmd > C:\Users\erene\dev\mevo_insa\k.log 2>&1
call C:\Users\erene\dev\mevo_insa\g.cmd > C:\Users\erene\dev\mevo_insa\g.log 2>&1
call "%~dp0derle.cmd" > C:\Users\erene\dev\mevo_insa\derle.log 2>&1
echo ZINCIR BITTI >> C:\Users\erene\dev\mevo_insa\derle.log
