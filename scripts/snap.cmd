@echo off
rem Wrapper so the script runs even when PowerShell execution policy is Restricted.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0snap.ps1" %*
