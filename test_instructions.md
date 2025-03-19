# X投稿管理システム テスト手順

## バックエンドのテスト

### 1. サーバーの起動
```
cd /home/ubuntu/x-post-manager/backend
rails s -p 3000
```

### 2. APIエンドポイントのテスト

#### キーワード管理API
```
# キーワード一覧の取得
curl -u admin:password http://localhost:3000/api/v1/keywords

# キーワードの追加
curl -u admin:password -X POST -H "Content-Type: application/json" -d '{"keyword":{"word":"エンジニア","active":true}}' http://localhost:3000/api/v1/keywords
```

#### ポスト取得API
```
# ポスト一覧の取得
curl -u admin:password http://localhost:3000/api/v1/posts
```

#### ポスト変換API
```
# ポストIDを指定して変換
curl -u admin:password -X POST http://localhost:3000/api/v1/posts/1/generate
```

#### スケジュールタスクのテスト
```
# 手動でタスクを実行
cd /home/ubuntu/x-post-manager/backend
bundle exec rake scheduler:fetch_posts
```

## フロントエンドのテスト

### 1. 開発サーバーの起動
```
cd /home/ubuntu/x-post-manager/frontend
npm start
```

### 2. ブラウザでアクセス
```
http://localhost:3001
```

### 3. テスト項目

#### トップページ
- [ ] ポスト一覧が表示されるか
- [ ] 「選択する」ボタンが機能するか

#### ポスト詳細ページ
- [ ] 選択したポストが表示されるか
- [ ] 「変換する」ボタンが機能するか
- [ ] 変換されたテキストが表示されるか
- [ ] 「Xに投稿する」ボタンが機能するか

## 本番環境のテスト

### 1. 環境変数の設定
- [ ] X API認証情報が正しく設定されているか
- [ ] Basic認証情報が正しく設定されているか

### 2. スケジュールタスクの確認
- [ ] cronジョブが正しく設定されているか
- [ ] ログファイルにエラーがないか

### 3. セキュリティチェック
- [ ] Basic認証が機能しているか
- [ ] 環境変数が安全に管理されているか

## 注意事項
- テスト中はX APIの呼び出し制限に注意してください
- 実際のXアカウントへの投稿テストは慎重に行ってください
