# インストールされているフォント一覧を表示
# List all installed fonts with usable names

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "インストール済みフォント一覧" -ForegroundColor Cyan
Write-Host "Installed Fonts List" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# フォントフォルダからフォントを取得
Add-Type -AssemblyName System.Drawing

$fonts = New-Object System.Drawing.Text.InstalledFontCollection
$fontList = $fonts.Families | Sort-Object Name

Write-Host "フォント数 / Total Fonts: $($fontList.Count)" -ForegroundColor Yellow
Write-Host ""
Write-Host "使用可能なフォント名 / Usable Font Names:" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Cyan

$counter = 1
foreach ($font in $fontList) {
    $fontName = $font.Name
    
    # 日本語フォントは色を変える
    if ($fontName -match '[\p{IsHiragana}\p{IsKatakana}\p{IsCJKUnifiedIdeographs}]') {
        Write-Host ("{0,4}. " -f $counter) -NoNewline -ForegroundColor Gray
        Write-Host $fontName -ForegroundColor Green
    } else {
        Write-Host ("{0,4}. " -f $counter) -NoNewline -ForegroundColor Gray
        Write-Host $fontName -ForegroundColor White
    }
    
    $counter++
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "使い方 / How to use:" -ForegroundColor Yellow
Write-Host ""
Write-Host "URLパラメータでフォントを指定:" -ForegroundColor White
Write-Host "  ?font=フォント名" -ForegroundColor Gray
Write-Host ""
Write-Host "例 / Examples:" -ForegroundColor White
Write-Host "  ?font=Meiryo" -ForegroundColor Gray
Write-Host "  ?font=Yu Gothic" -ForegroundColor Gray
Write-Host "  ?font=メイリオ" -ForegroundColor Gray
Write-Host ""
Write-Host "複数フォント指定 (フォールバック):" -ForegroundColor White
Write-Host "  ?font=Yu Gothic,Meiryo,sans-serif" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ファイルに出力するか確認
$saveChoice = Read-Host "フォント一覧をファイルに保存しますか? / Save to file? [Y/n]"

if ($saveChoice -eq "" -or $saveChoice -match "^[Yy]" -or $saveChoice -match "^[Yy][Ee][Ss]$") {
    $outputFile = "font_list.txt"
    
    $output = @()
    $output += "=========================================="
    $output += "インストール済みフォント一覧 / Installed Fonts List"
    $output += "生成日時 / Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $output += "=========================================="
    $output += ""
    $output += "フォント数 / Total: $($fontList.Count)"
    $output += ""
    
    $counter = 1
    foreach ($font in $fontList) {
        $output += ("{0,4}. {1}" -f $counter, $font.Name)
        $counter++
    }
    
    $output += ""
    $output += "=========================================="
    $output += "使い方 / How to use:"
    $output += "URLパラメータ: ?font=フォント名"
    $output += "例: ?font=Meiryo"
    $output += "=========================================="
    
    $output | Out-File -FilePath $outputFile -Encoding UTF8
    
    Write-Host ""
    Write-Host "? 保存しました / Saved: $outputFile" -ForegroundColor Green
    
    # 保存場所を表示
    $fullPath = (Get-Item $outputFile).FullName
    Write-Host "  場所 / Location: $fullPath" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Enterキーで終了 / Press Enter to exit..." -ForegroundColor Gray
$null = Read-Host
