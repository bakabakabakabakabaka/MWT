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
title FWE
echo -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo Fix Windows Effects (FWE)
echo By Baka
echo -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo Sometimes acrylic, and transparency effects break. This will fix it.
pause
cls
echo Before continuing, check the ForceEffectMode value.
echo If the value displays "0x0, or 0x1" press ENTER.
echo Press ENTER to continue, CTRL+C to cancel.
call :colorEcho 40 "IF THE SYSTEM REPORTS
call :colorEcho 40 " 'The system was unable to find the specified registry key or value.' YOU NEED TO PRESS ENTER!"
reg query HKLM\SOFTWARE\Microsoft\Windows\Dwm /v ForceEffectMode
pause
pause
echo (Type yes)
reg add HKLM\SYSTEM\CurrentControlSet\Control /v PortableOperatingSystem /t REG_DWORD /d 2
cls
echo Done. (You will need to restart your computer)
echo Press ENTER to restart, to restart later press CTRL+C.
pause
shutdown /r /t 0

:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i