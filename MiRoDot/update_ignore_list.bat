@echo off
setlocal

echo ========================================
echo 除外ユーザーリスト更新ツール
echo Excluded Users List Updater
echo ========================================
echo.
echo PowerShell を起動しています...
echo Starting PowerShell...
echo.

:: PowerShellスクリプトを実行
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update_ignore_list.ps1"

exit /b 0