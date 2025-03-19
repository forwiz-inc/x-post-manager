class Api::V1::ScheduledTasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /api/v1/scheduled_tasks/fetch_posts
  def fetch_posts
    # アクティブなキーワードを取得
    active_keywords = Keyword.where(active: true).pluck(:word)
    
    if active_keywords.empty?
      render json: { error: "アクティブなキーワードが設定されていません" }, status: :unprocessable_entity
      return
    end

    # X APIを使用して投稿を検索
    x_client = XApiClient.new
    search_results = x_client.search_posts(active_keywords)
    
    if search_results[:error].present?
      render json: { error: search_results[:error] }, status: :unprocessable_entity
      return
    end
    
    # 検索結果を処理して保存
    saved_posts = process_and_save_posts(search_results, active_keywords)
    
    render json: { success: true, posts_count: saved_posts.size }
  end

  private
  
  def process_and_save_posts(search_results, keywords)
    saved_posts = []
    
    # APIレスポンスの構造に応じて処理
    tweets = search_results['data'] || []
    users = {}
    
    # ユーザー情報をマッピング
    if search_results['includes'] && search_results['includes']['users']
      search_results['includes']['users'].each do |user|
        users[user['id']] = user
      end
    end
    
    tweets.each do |tweet|
      # すでに存在するポストはスキップ
      next if Post.exists?(x_post_id: tweet['id'])
      
      # ユーザー情報を取得
      user = users[tweet['author_id']] || {}
      
      # いいね数を取得
      likes_count = tweet.dig('public_metrics', 'like_count') || 0
      
      # 投稿日時をパース
      posted_at = tweet['created_at'] ? Time.parse(tweet['created_at']) : Time.current
      
      # 1ヶ月以内の投稿かつ10いいね以上のみ保存
      next if posted_at < 1.month.ago || likes_count < 10
      
      # ポストを作成
      post = Post.new(
        x_post_id: tweet['id'],
        content: tweet['text'],
        author_username: user['username'],
        author_name: user['name'],
        likes_count: likes_count,
        posted_at: posted_at,
        used: false
      )
      
      if post.save
        saved_posts << post
        
        # キーワードとの関連付け
        keywords.each do |keyword|
          if post.content.downcase.include?(keyword.downcase)
            keyword_record = Keyword.find_by(word: keyword)
            PostKeyword.create(post: post, keyword: keyword_record) if keyword_record
          end
        end
      end
    end
    
    saved_posts
  end
end
