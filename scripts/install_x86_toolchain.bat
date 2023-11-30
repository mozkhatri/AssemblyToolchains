@echo off

REM Installation script for the x86 toolchain script for Windows

REM Created by Amos Leung
REM ISS Program, SADT, SAIT
REM October 2023


REM Change the path to the directory where you want to install the script
set INSTALL_PATH=C:\x86_toolchain

REM Copy the script to the installation directory
REM "/Y" switch is included to suppress prompting to confirm overwriting the destination file
copy /Y "x86_toolchain.sh" "%INSTALL_PATH%"

REM Add the installation directory to the system PATH
REM "/M" switch is included to set the system-wide PATH variable
setx PATH "%PATH%;%INSTALL_PATH%" /M

echo Installation Completed.
