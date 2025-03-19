class Api::V1::PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_post, only: [:show, :update]

  # GET /api/v1/posts
  def index
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
    
    # 未使用のポストを取得（いいね数が10以上、1ヶ月以内に投稿されたもの）
    one_month_ago = 1.month.ago
    posts = Post.where(used: false)
                .where('likes_count >= ?', 10)
                .where('posted_at >= ?', one_month_ago)
                .order(likes_count: :desc)
                .limit(20)
    
    render json: posts
  end

  # GET /api/v1/posts/:id
  def show
    render json: @post
  end

  # POST /api/v1/posts/:id/generate
  def generate
    post = Post.find(params[:id])
    
    # OpenAI APIを使用してテキスト生成（実際の実装ではAIサービスを使用）
    original_content = post.content
    generated_content = transform_content(original_content)
    
    # 生成したポストを保存
    generated_post = post.generated_posts.create(content: generated_content)
    
    if generated_post.persisted?
      render json: generated_post, status: :created
    else
      render json: { error: generated_post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/posts/:id/publish
  def publish
    post = Post.find(params[:id])
    generated_post = GeneratedPost.find(params[:generated_post_id])
    
    # X APIを使用して投稿
    x_client = XApiClient.new
    result = x_client.post_tweet(generated_post.content)
    
    if result[:error].present?
      render json: { error: result[:error] }, status: :unprocessable_entity
      return
    end
    
    # 投稿成功したらフラグを更新
    post.update(used: true)
    generated_post.update(posted: true, posted_at: Time.current)
    
    render json: { success: true, post: post, generated_post: generated_post }
  end

  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def process_and_save_posts(search_results, keywords)
    saved_posts = []
    
    # APIレスポンスの構造に応じて処理
    # 注: 実際のAPIレスポンス構造に合わせて調整が必要
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
  
  def transform_content(original_content)
    # TextTransformServiceを使用してテキスト変換
    TextTransformService.transform_content(original_content)
  end
end
