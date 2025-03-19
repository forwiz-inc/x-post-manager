# X投稿管理システム デプロイ手順

## 前提条件
- Ruby 3.0以上
- Node.js 16以上
- PostgreSQL 12以上
- X API開発者アカウント（APIキーとシークレットが必要）

## 環境変数の設定

以下の環境変数を設定してください。

```
# X API認証情報
X_CLIENT_ID=your_client_id_here
X_CLIENT_SECRET=your_client_secret_here
X_CALLBACK_URL=http://your-domain.com/api/v1/auth/callback
X_BEARER_TOKEN=your_bearer_token_here

# Basic認証情報
BASIC_AUTH_USERNAME=admin
BASIC_AUTH_PASSWORD=your_secure_password

# フロントエンド URL
FRONTEND_URL=http://your-domain.com
```

## バックエンドのデプロイ

1. リポジトリをクローン
```
git clone https://github.com/your-repo/x-post-manager.git
cd x-post-manager/backend
```

2. 依存関係のインストール
```
bundle install
```

3. データベースのセットアップ
```
rails db:create
rails db:migrate
```

4. 本番環境用の設定
```
RAILS_ENV=production rails assets:precompile
```

5. サーバーの起動
```
RAILS_ENV=production rails s -p 3000
```

## フロントエンドのデプロイ

1. フロントエンドディレクトリに移動
```
cd ../frontend
```

2. 依存関係のインストール
```
npm install
```

3. 本番用ビルドの作成
```
npm run build
```

4. ビルドファイルをWebサーバーにデプロイ
```
# 例: Nginxの場合
cp -r build/* /var/www/html/
```

## スケジュールタスクの設定

1. cronに毎日のタスクを設定
```
# 毎日午前3時に実行する例
0 3 * * * /path/to/x-post-manager/backend/bin/fetch_posts.sh
```

## 動作確認

1. バックエンドAPIが正常に動作していることを確認
```
curl -u admin:your_secure_password http://your-domain.com/api/v1/posts
```

2. フロントエンドにアクセスして表示を確認
```
http://your-domain.com
```

## トラブルシューティング

- ログの確認
```
tail -f /path/to/x-post-manager/backend/log/production.log
```

- X API認証エラーの場合は、APIキーとシークレットを再確認してください
- データベース接続エラーの場合は、PostgreSQLの設定を確認してください
