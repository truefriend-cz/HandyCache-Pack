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
title Checking Microsoft Visual C++ in the system

echo Checking Microsoft Visual C++ (32 bit) in the system...
for /f "skip=1 tokens=1 delims=." %%a IN ('wmic product where 'Name like "%%Microsoft Visual C++%%x86%%"' get version ^| findstr "."') do (
	if %%a == 11 set "two_thousand_twelve_32=yes"
	if %%a == 14 set "two_thousand_seventeen_32=yes"
)
echo Checking Microsoft Visual C++ (64 bit) in the system...
for /f "skip=1 tokens=1 delims=." %%a IN ('wmic product where 'Name like "%%Microsoft Visual C++%%x64%%"' get version ^| findstr "."') do (
	if %%a == 11 set "two_thousand_twelve_64=yes"
	if %%a == 14 set "two_thousand_seventeen_64=yes"
)

echo. 
if "%two_thousand_twelve_32%" NEQ "yes" (title Install Microsoft Visual C++ 2012 (32 bit) & cls & echo Microsoft Visual C++ 2012 (32 bit) not found in this OS. & echo. & echo Installing... & echo. & start "" /wait "%ThisDir%\Bin\vcredist2012_x86.exe" /errorsaswarnings /q /norestart>nul 2>&1 & if %errorlevel%==0 echo Microsoft Visual C++ 2012 successfully installed. & ping.exe 127.0.0.1 -n 4 >nul 2>&1&)
if "%two_thousand_seventeen_32%" NEQ "yes" (title Install Microsoft Visual C++ 2017 (32 bit) & cls & echo Microsoft Visual C++ 2017 (32 bit) not found in this OS. & echo. & echo Installing... & echo. & start "" /wait "%ThisDir%\Bin\vcredist2017_x86.exe" /errorsaswarnings /q /norestart>nul 2>&1 & if %errorlevel%==0 echo Microsoft Visual C++ 2017 successfully installed. & ping.exe 127.0.0.1 -n 4 >nul 2>&1&)
if "%two_thousand_twelve_64%" NEQ "yes" (title Install Microsoft Visual C++ 2012 (64 bit) & cls & echo Microsoft Visual C++ 2012 (64 bit) not found in this OS. & echo. & echo Installing... & echo. & start "" /wait "%ThisDir%\Bin\vcredist2012_x64.exe" /errorsaswarnings /q /norestart>nul 2>&1 & if %errorlevel%==0 echo Microsoft Visual C++ 2012 successfully installed. & ping.exe 127.0.0.1 -n 4 >nul 2>&1&)
if "%two_thousand_seventeen_64%" NEQ "yes" (title Install Microsoft Visual C++ 2017 (64 bit) & cls & echo Microsoft Visual C++ 2017 (64 bit) not found in this OS. & echo. & echo Installing... & echo. & start "" /wait "%ThisDir%\Bin\vcredist2017_x64.exe" /errorsaswarnings /q /norestart>nul 2>&1 & if %errorlevel%==0 echo Microsoft Visual C++ 2017 successfully installed. & ping.exe 127.0.0.1 -n 4 >nul 2>&1&)

if "%two_thousand_twelve_32%" EQU "yes" if "%two_thousand_seventeen_32%" EQU "yes" (echo Microsoft Visual C++ (32 bit) Installed & echo Exiting... & ping.exe 127.0.0.1 -n 4 >nul 2>&1&)
if "%two_thousand_twelve_64%" EQU "yes" if "%two_thousand_seventeen_64%" EQU "yes" (echo Microsoft Visual C++ (64 bit) Installed & echo Exiting... & ping.exe 127.0.0.1 -n 4 >nul 2>&1&)

exit