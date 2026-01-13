@echo off
setlocal enabledelayedexpansion

echo ========================================
echo OBS コメントオーバーレイ URL生成ツール
echo OBS Comment Overlay URL Generator
echo ========================================
echo.

:: Get current folder path
set "FOLDER_PATH=%~dp0"
if "%FOLDER_PATH:~-1%"=="\" set "FOLDER_PATH=%FOLDER_PATH:~0,-1%"

:: Convert backslashes to forward slashes
set "URL_PATH=%FOLDER_PATH:\=/%"

set "BASE_URL=file:///%URL_PATH%/niconico_comments.html"

:: Default values
set "DEFAULT_FLOWTIME=5"
set "DEFAULT_COLOR=FFFFFF"
set "DEFAULT_FONT=MS PGothic, Meiryo, sans-serif"
set "DEFAULT_SIZE=middle"

:: Interactive input
echo パラメータを入力してください (Enter でデフォルト値):
echo Enter parameters (press Enter to use default):
echo.

:: Flow time
set /p "INPUT_FLOWTIME=流れる時間(秒) / Flow time in seconds [%DEFAULT_FLOWTIME%]: "
if "!INPUT_FLOWTIME!"=="" set "INPUT_FLOWTIME=%DEFAULT_FLOWTIME%"

:: Color
set /p "INPUT_COLOR=デフォルト文字色 / Default text color [%DEFAULT_COLOR%]: "
if "!INPUT_COLOR!"=="" set "INPUT_COLOR=%DEFAULT_COLOR%"

:: Font
set /p "INPUT_FONT=フォント / Font family [%DEFAULT_FONT%]: "
if "!INPUT_FONT!"=="" set "INPUT_FONT=%DEFAULT_FONT%"

:: Size
set /p "INPUT_SIZE=デフォルトサイズ / Default size (small/middle/big) [%DEFAULT_SIZE%]: "
if "!INPUT_SIZE!"=="" set "INPUT_SIZE=%DEFAULT_SIZE%"

:: Build URL with all parameters
set "FINAL_URL=%BASE_URL%?flowtime=!INPUT_FLOWTIME!&color=!INPUT_COLOR!&font=!INPUT_FONT!&size=!INPUT_SIZE!"

:: Display result
echo.
echo ========================================
echo 生成されたURL / Generated URL:
echo ========================================
echo !FINAL_URL!
echo.

:: Ask for clipboard copy
set /p "COPY_CHOICE=クリップボードにコピーしますか? / Copy to clipboard? [Y/n]: "

:: Check if input is empty (Enter key), Y/y, YES/yes/Yes, or any case variation
if "!COPY_CHOICE!"=="" goto DO_COPY
if /i "!COPY_CHOICE!"=="y" goto DO_COPY
if /i "!COPY_CHOICE!"=="yes" goto DO_COPY
if /i "!COPY_CHOICE!"=="n" goto SKIP_COPY
if /i "!COPY_CHOICE!"=="no" goto SKIP_COPY

:: Default to copy if input is not recognized
goto DO_COPY

:DO_COPY
:: Use PowerShell to copy to clipboard (avoids & interpretation)
powershell -command "Set-Clipboard -Value '!FINAL_URL!'"
echo.
echo [クリップボードにコピーしました / COPIED TO CLIPBOARD]
goto END

:SKIP_COPY
echo.
echo [コピーしませんでした / NOT COPIED]
goto END

:END
echo.
echo ========================================
echo OBS での使い方 / How to use in OBS:
echo 1. ブラウザソースを追加 / Add Browser Source
echo 2. 「ローカルファイル」のチェックを外す / UNCHECK "Local file"
echo 3. URL欄に貼り付け / Paste URL in URL field
echo 4. 幅:1920 高さ:1080 に設定 / Set Width: 1920, Height: 1080
echo ========================================
echo.
pause
exit /b 0
