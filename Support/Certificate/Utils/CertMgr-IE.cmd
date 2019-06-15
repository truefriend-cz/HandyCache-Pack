@echo off
rem --> Check for permissions
>nul 1>nul 2>nul "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

rem --> If error flag set, we do not have admin.
if "%errorlevel%" neq "0" (
	echo Requesting administrative privileges...
	ping.exe 127.0.0.1 -n 2 >nul 1>nul 2>nul
	goto UACPrompt
) else (
	goto gotAdmin
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"="
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%cd%"
cd /D "%~dp0"

rem --> Start

start "" "rundll32.exe" cryptui.dll,CryptUIStartCertMgr

exit