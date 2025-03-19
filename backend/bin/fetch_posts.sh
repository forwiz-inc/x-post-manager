#!/bin/bash

# このスクリプトは毎日特定の時間に実行されるようにcronに設定します
# 例: 0 3 * * * /path/to/fetch_posts.sh

# Railsアプリケーションのディレクトリに移動
cd /home/ubuntu/x-post-manager/backend

# 環境変数を読み込む（必要に応じて）
source /home/ubuntu/.bashrc

# Railsタスクを実行
RAILS_ENV=production bundle exec rake scheduler:fetch_posts
