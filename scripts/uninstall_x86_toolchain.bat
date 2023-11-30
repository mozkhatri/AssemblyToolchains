@echo off

REM Uninstallation script for the x86 toolchain script for Windows

REM Created by Amos Leung
REM ISS Program, SADT, SAIT
REM October 2023


REM Change the path to the installation directory
set INSTALL_PATH=C:\x86_toolchain

REM Remove the script from the installation directory
REM "/f" switch is included to force delete the file without asking for confirmation
del /f "%INSTALL_PATH%\x86_toolchain.sh"

REM Remove the installation directory from the system PATH
REM "/M" switch is included to ensure that the change affects the system-wide PATH variable
setx PATH "%PATH:;C:\x86_toolchain=%" /M

echo Uninstallation Completed.
