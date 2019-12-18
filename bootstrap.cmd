@echo off

echo Installing Linux subsystem for Windows
Dism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All

echo Installed Linux subsystem for Windows. Please reboot.
