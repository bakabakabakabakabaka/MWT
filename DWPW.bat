@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------  
cls
title DWPW V1
echo -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo Disable Windows Portable Workstation Script (DWPW)
echo By Baka
echo -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo This will fix the "This feature is not available in a portable workstation environment." and/or "You cannot upgrade on a USB device."
pause
cls
echo Before continuing, check the PortableOperatingSystem value.
echo If the value displays, "0x0" you can cancel. Otherwise press ENTER.
echo Press ENTER to continue, CTRL+C to cancel.
call :colorEcho 40 "IF THE SYSTEM REPORTS
call :colorEcho 40 " 'The system was unable to find the specified registry key or value.' YOU NEED TO PRESS ENTER!"
reg query HKLM\SYSTEM\CurrentControlSet\Control /v PortableOperatingSystem
pause
echo (Type yes)
reg add HKLM\SYSTEM\CurrentControlSet\Control /v PortableOperatingSystem /t REG_DWORD /d 0
cls
echo Done.
pause
exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i