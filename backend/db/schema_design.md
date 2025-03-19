# データベーススキーマ設計

## テーブル構成

### 1. keywords（キーワード）
- id: integer (primary key)
- word: string (検索キーワード)
- active: boolean (有効/無効フラグ)
- created_at: datetime
- updated_at: datetime

### 2. posts（取得したポスト）
- id: integer (primary key)
- x_post_id: string (Xのポスト固有ID)
- content: text (ポストの内容)
- author_username: string (投稿者のユーザー名)
- author_name: string (投稿者の表示名)
- likes_count: integer (いいね数)
- posted_at: datetime (投稿日時)
- used: boolean (使用済みフラグ)
- created_at: datetime
- updated_at: datetime

### 3. generated_posts（生成したポスト）
- id: integer (primary key)
- original_post_id: integer (references posts)
- content: text (生成したポストの内容)
- posted: boolean (投稿済みフラグ)
- posted_at: datetime (投稿日時)
- created_at: datetime
- updated_at: datetime

### 4. post_keywords（ポストとキーワードの関連付け）
- id: integer (primary key)
- post_id: integer (references posts)
- keyword_id: integer (references keywords)
- created_at: datetime
- updated_at: datetime

## リレーション

- keywords has_many post_keywords
- keywords has_many posts, through: post_keywords
- posts has_many post_keywords
- posts has_many keywords, through: post_keywords
- posts has_many generated_posts
- generated_posts belongs_to posts

## インデックス

- keywords: word (一意)
- posts: x_post_id (一意)
- posts: posted_at
- posts: used
- post_keywords: [post_id, keyword_id] (一意)
- generated_posts: original_post_id
- generated_posts: posted
