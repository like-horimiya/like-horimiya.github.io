@echo off
setlocal

echo ========================================
echo インストール済みフォント一覧
echo Installed Fonts List
echo ========================================
echo.
echo PowerShell を起動しています...
echo Starting PowerShell...
echo.

:: PowerShellスクリプトを実行
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0list_fonts.ps1"

exit /b 0
