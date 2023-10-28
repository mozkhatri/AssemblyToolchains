@echo off

REM Installation script for the x86 toolchain script for Windows

REM Created by Amos Leung
REM ISS Program, SADT, SAIT
REM October 2023


REM Change the path to the directory where you want to install the script
set INSTALL_PATH=C:\x86_toolchain

REM Copy the script to the installation directory
copy x86_toolchain.sh %INSTALL_PATH%

REM Add the installation directory to the system PATH
setx PATH "%PATH%;%INSTALL_PATH%"

echo Installation Completed.
