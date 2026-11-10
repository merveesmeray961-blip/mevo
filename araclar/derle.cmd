@echo off
chcp 65001 >nul
set SRC=%~dp0..\app
set DST=C:\Users\erene\dev\mevo_insa\app
set SURUM=1.1.4
set OUT=C:\Users\erene\dev\mevo_insa\cikti_%SURUM%
set "JAVA_HOME=C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"
robocopy "%SRC%" "%DST%" /MIR /XD build .dart_tool .gradle .kotlin /XF key.properties local.properties /NFL /NDL /NJH /NJS /NP
cd /d %DST%
call flutter pub get
if not exist %OUT% mkdir %OUT%
for %%F in (smmm ymm) do (
  echo === AAB %%F
  call flutter build appbundle --release --flavor %%F --obfuscate --split-debug-info=build/hata-ayiklama-%%F
  echo === APK %%F
  call flutter build apk --release --flavor %%F --split-per-abi --obfuscate --split-debug-info=build/hata-ayiklama-%%F
)
copy /y build\app\outputs\bundle\smmmRelease\app-smmm-release.aab %OUT%\Mizan-SMMM_%SURUM%_Play-Yukleme.aab
copy /y build\app\outputs\bundle\ymmRelease\app-ymm-release.aab %OUT%\Tasdik-YMM_%SURUM%_Play-Yukleme.aab
copy /y build\app\outputs\flutter-apk\app-arm64-v8a-smmm-release.apk %OUT%\Mizan-SMMM_%SURUM%_Telefon-Test.apk
copy /y build\app\outputs\flutter-apk\app-arm64-v8a-ymm-release.apk %OUT%\Tasdik-YMM_%SURUM%_Telefon-Test.apk
dir %OUT%
echo === BITTI
