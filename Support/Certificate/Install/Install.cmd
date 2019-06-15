@echo off
:checkPrivileges
net file 1>nul 2>nul
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
echo.
echo.
echo.     **************************************************
echo.
echo.          Invoking UAC for Privilege Escalation...
echo.
echo.     **************************************************
echo.
echo.
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
echo UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

echo Current path is %cd%
echo Changing directory to the path of the current script
cd %~dp0
echo Current path is %cd%

:gotPrivileges

rem --> Start
set "ThisDir=%~dp0"
set "ThisDir=%ThisDir:~0,-1%"
set "ScriptName=%~n0.cmd"
pushd "%ThisDir%"
for %%* in (.) do (set "UpperDir=%%~nx*")
title Install Certificate

rem --> Define OS
setlocal
for /f "tokens=2 delims=[]" %%i in ('ver') do set version=%%i
for /f "tokens=2-3 delims=. " %%i in ("%version%") do set version=%%i.%%j
:: 2000
if "%version%" == "5.00" (set "os_short=XP")
:: 2000
if "%version%" == "5.0" (set "os_short=XP")
:: XP
if "%version%" == "5.1" (set "os_short=XP")
:: 2003
if "%version%" == "5.2" (set "os_short=XP")
:: Vista
if "%version%" == "6.0" (set "os_short=7")
:: 7
if "%version%" == "6.1" (set "os_short=7")
:: 8
if "%version%" == "6.2" (set "os_short=10")
:: 8.1
if "%version%" == "6.3" (set "os_short=10")
:: 10
if "%version%" == "6.4" (set "os_short=10")
:: 10
if "%version%" == "10.0" (set "os_short=10")

if not defined os_short (
	echo "Error: No detected system version"
	pause
	exit
)

rem --> Define OS bit
if %processor_architecture% == x86 (set "bit=x32") && (set "exist=yes")
if %processor_architecture% == AMD64 (set "bit=x64") && (set "exist=yes")
if not defined exist (
	echo Error: No detected processor architecture.
	pause
	exit
)

rem --> Check exist in OS and install
for /f "tokens=4 delims=/" %%A in ('""%ThisDir%\Bin\OpenSSL\%bit%\OpenSSL.exe" x509 -in "%ThisDir%\Certificate\root-public.crt" -noout -subject 2>nul"') do for /f "tokens=2 delims==" %%B in ("%%A") do set "varfile=%%B"
for /f "usebackq tokens=1" %%A in (`call "%ThisDir%\Bin\CertUtil-%os_short%.exe" -user -enterprise -v -store root ^| find "OU=SSL_handling"`) do for /f "tokens=2 delims==" %%B in ("%%A") do set "varstore=%%B"
for %%A in ("%varfile%") do for %%B in ("%varstore%") do if "%%~fA" NEQ "%%~fB" (echo Certificate not found in this OS. & echo. & echo Installing Certificate... & echo. & "%ThisDir%\Bin\CertUtil-%os_short%.exe" -addstore -f -enterprise -user root "%ThisDir%\Certificate\root-public.crt">nul 2>&1 & if %errorlevel%==0 echo Success & echo. & echo. & ping.exe 127.0.0.1 -n 4 >nul 1>nul 2>nul)

rem --> End
exit
