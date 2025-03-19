namespace :scheduler do
  desc "X APIから投稿を取得する"
  task fetch_posts: :environment do
    # アクティブなキーワードを取得
    active_keywords = Keyword.where(active: true).pluck(:word)
    
    if active_keywords.empty?
      puts "アクティブなキーワードが設定されていません"
      next
    end

    puts "#{active_keywords.size}個のキーワードで投稿を検索します: #{active_keywords.join(', ')}"

    # X APIを使用して投稿を検索
    x_client = XApiClient.new
    search_results = x_client.search_posts(active_keywords)
    
    if search_results[:error].present?
      puts "エラー: #{search_results[:error]}"
      next
    end
    
    # 検索結果を処理して保存
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
    
    puts "#{saved_posts.size}件の新しい投稿を保存しました"
  end
end
