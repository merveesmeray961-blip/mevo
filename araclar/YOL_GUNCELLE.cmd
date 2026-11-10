@echo off
rem Proje klasorunun adi/yeri degisince bunu cift tiklayin: zamanlanmis gorev, masaustu kisayolu ve derleme betigi yeni yola baglanir.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$k=(Resolve-Path '%~dp0..').Path; $d=Join-Path $k 'mevzuat_takip';" ^
 "$py=(Get-Command pythonw).Source; $a=New-ScheduledTaskAction -Execute $py -Argument 'tara.py' -WorkingDirectory $d;" ^
 "$t1=New-ScheduledTaskTrigger -Daily -At 08:20; $t2=New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME; $t2.Delay='PT5M';" ^
 "$s=New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 2);" ^
 "Register-ScheduledTask -TaskName 'MevzuatTakip' -Action $a -Trigger $t1,$t2 -Settings $s -Force | Out-Null;" ^
 "$sh=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Mevzuat Takip.lnk'); $sh.TargetPath=(Join-Path $d 'panel.html'); $sh.Save();" ^
 "$a2=Join-Path $k 'araclar'; Set-Content -Encoding UTF8 'C:\Users\erene\dev\mevo_insa\s112.ps1' ('& cmd /c \"'+$a2+'\kontrol.cmd\" *> C:\Users\erene\dev\mevo_insa\kontrol.log; & cmd /c \"'+$a2+'\derle.cmd\" *> C:\Users\erene\dev\mevo_insa\derle.log; ''ZINCIR BITTI'' | Add-Content C:\Users\erene\dev\mevo_insa\derle.log');" ^
 "Write-Host ('Tamam. Yeni proje yolu: '+$k)"
pause
