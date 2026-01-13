# 除外ユーザーリスト 使い方ガイド

## 📝 概要

`ignore.txt` に書いたユーザー名をコメント表示から除外できます。
HTMLファイルを編集する必要はありません。

## 🚀 使い方

### 1. ignore.txt を編集

`ignore.txt` をテキストエディタで開き、除外したいユーザー名を追加：

```
# ボット
Nightbot
StreamElements

# 除外したいユーザー
迷惑なユーザー1
迷惑なユーザー2
```

### 2. 更新ツールを実行

**`update_ignore_list.bat`** をダブルクリック

または

**`update_ignore_list.ps1`** を右クリック → PowerShellで実行

### 3. OBSで更新

OBSのブラウザソースを右クリック → **更新**

## 📋 ignore.txt の書き方

```
# コメント行（#で始まる）
除外ユーザー1
除外ユーザー2

# 空行も使えます

除外ユーザー3
```

### ルール
- **1行に1ユーザー名**
- **#で始まる行** はコメント（無視される）
- **空行** は無視される
- **大文字小文字を区別** します

## 🔄 更新の流れ

```
ignore.txt を編集
    ↓
update_ignore_list.bat 実行
    ↓
niconico_comments.html が自動更新
    ↓
OBSでブラウザソースを更新
    ↓
除外ユーザーが反映される
```

## 💾 バックアップ

更新ツールを実行すると、自動的にバックアップが作成されます：
- **バックアップファイル**: `niconico_comments.backup.html`

### 元に戻す方法
1. `niconico_comments.backup.html` を `niconico_comments.html` にリネーム
2. OBSで更新

## ✅ 動作確認

更新後、OBSのブラウザソースで **F12** を押し、コンソールを確認：

```
設定: {
  ...
  excludedUsers: "3人"
}
```

除外ユーザーのコメントは表示されません。

## 🔍 トラブルシューティング

### 除外されない場合

1. **ユーザー名が正確か確認**
   - わんコメで表示される名前と完全に一致する必要があります
   - 大文字小文字も区別されます

2. **OBSで更新したか確認**
   - ブラウザソースを右クリック → 更新

3. **コンソールでログ確認**
   - F12 → コンソール
   - "除外ユーザー: [名前]" が表示されるはず

### PowerShellスクリプトが実行できない

管理者権限でPowerShellを開き：
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📁 必要なファイル

同じフォルダに以下のファイルが必要：
- ✅ `niconico_comments.html`
- ✅ `ignore.txt`
- ✅ `update_ignore_list.bat` (または .ps1)

## 💡 ヒント

### 複数人を一度に追加
ignore.txt にまとめて書いて、一度だけ更新ツールを実行

### 一時的に無効化
ユーザー名の前に `#` を付ける：
```
# Nightbot  ← 一時的に無効
StreamElements
```

### テスト
1. ignore.txt にテストユーザーを追加
2. 更新ツール実行
3. そのユーザーでコメント送信
4. 表示されなければ成功！
