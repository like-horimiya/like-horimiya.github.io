# ignore.txtからHTMLファイルの除外ユーザーリストを更新するスクリプト
# Update excluded users list in HTML from ignore.txt

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "除外ユーザーリスト更新ツール" -ForegroundColor Cyan
Write-Host "Excluded Users List Updater" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# スクリプトのあるフォルダ
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# ファイルパス
$ignoreFile = Join-Path $scriptPath "ignore.txt"
$htmlFile = Join-Path $scriptPath "niconico_comments.html"
$backupFile = Join-Path $scriptPath "niconico_comments.backup.html"

# ファイルの存在確認
if (-not (Test-Path $ignoreFile)) {
    Write-Host "? エラー / Error:" -ForegroundColor Red
    Write-Host "  ignore.txt が見つかりません" -ForegroundColor Red
    Write-Host "  ignore.txt not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "  場所 / Location: $ignoreFile" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Enterキーで終了 / Press Enter to exit..." -ForegroundColor Gray
    $null = Read-Host
    exit 1
}

if (-not (Test-Path $htmlFile)) {
    Write-Host "? エラー / Error:" -ForegroundColor Red
    Write-Host "  niconico_comments.html が見つかりません" -ForegroundColor Red
    Write-Host "  niconico_comments.html not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "  場所 / Location: $htmlFile" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Enterキーで終了 / Press Enter to exit..." -ForegroundColor Gray
    $null = Read-Host
    exit 1
}

# ignore.txtを読み込む
Write-Host "? ignore.txt を読み込み中..." -ForegroundColor Yellow
Write-Host "   Reading ignore.txt..." -ForegroundColor Yellow
Write-Host ""

$ignoredUsers = Get-Content $ignoreFile -Encoding UTF8 | Where-Object {
    $_ -and                    # 空行でない
    $_.Trim() -ne "" -and      # 空白のみでない
    -not $_.Trim().StartsWith("#")  # コメント行でない
} | ForEach-Object { $_.Trim() }

Write-Host "除外ユーザー数 / Excluded users: $($ignoredUsers.Count)" -ForegroundColor Green
if ($ignoredUsers.Count -gt 0) {
    Write-Host ""
    Write-Host "除外するユーザー / Users to exclude:" -ForegroundColor Yellow
    foreach ($user in $ignoredUsers) {
        Write-Host "  - $user" -ForegroundColor White
    }
}
Write-Host ""

# HTMLファイルのバックアップ
Write-Host "? バックアップを作成中..." -ForegroundColor Yellow
Write-Host "   Creating backup..." -ForegroundColor Yellow
Copy-Item $htmlFile $backupFile -Force
Write-Host "   ? バックアップ完了 / Backup created: niconico_comments.backup.html" -ForegroundColor Green
Write-Host ""

# HTMLファイルを読み込む
$htmlContent = Get-Content $htmlFile -Raw -Encoding UTF8

# JavaScript配列を生成
$jsArray = "const EXCLUDED_USERS = ["
if ($ignoredUsers.Count -eq 0) {
    $jsArray += "`n            // 除外ユーザーなし / No excluded users`n        ];"
} else {
    $jsArray += "`n"
    foreach ($user in $ignoredUsers) {
        # JavaScriptの文字列としてエスケープ
        $escapedUser = $user -replace "\\", "\\\\" -replace "'", "\'" -replace '"', '\"'
        $jsArray += "            '$escapedUser',`n"
    }
    $jsArray += "        ];"
}

# 正規表現で置換（const EXCLUDED_USERS = [ ... ]; の部分を置換）
$pattern = '(?s)const EXCLUDED_USERS = \[.*?\];'
$newContent = $htmlContent -replace $pattern, $jsArray

# HTMLファイルを書き込む
Write-Host "??  HTMLファイルを更新中..." -ForegroundColor Yellow
Write-Host "   Updating HTML file..." -ForegroundColor Yellow
$newContent | Out-File -FilePath $htmlFile -Encoding UTF8 -NoNewline
Write-Host "   ? 更新完了 / Update completed" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "? 完了 / Completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "変更内容 / Changes:" -ForegroundColor Yellow
Write-Host "  - 除外ユーザー数 / Excluded users: $($ignoredUsers.Count)" -ForegroundColor White
Write-Host "  - バックアップ / Backup: niconico_comments.backup.html" -ForegroundColor White
Write-Host ""
Write-Host "次のステップ / Next steps:" -ForegroundColor Yellow
Write-Host "  1. OBSのブラウザソースを更新" -ForegroundColor White
Write-Host "     Refresh browser source in OBS" -ForegroundColor Gray
Write-Host "  2. 除外ユーザーが反映されます" -ForegroundColor White
Write-Host "     Excluded users will be applied" -ForegroundColor Gray
Write-Host ""
Write-Host "元に戻すには / To restore:" -ForegroundColor Yellow
Write-Host "  niconico_comments.backup.html を niconico_comments.html にリネーム" -ForegroundColor White
Write-Host "  Rename backup file to original name" -ForegroundColor Gray
Write-Host ""

Write-Host "Enterキーで終了 / Press Enter to exit..." -ForegroundColor Gray
$null = Read-Host