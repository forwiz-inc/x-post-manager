class Api::V1::ScheduledTasksController < ApplicationController
  skip_before_action :authenticate, only: [:fetch_posts]

  def fetch_posts
    client = XApiClient.new
    active_keywords = Keyword.where(active: true)
    
    posts_count = 0
    
    active_keywords.each do |keyword|
      search_results = client.search_posts(keyword.word)
      
      if search_results["data"].present?
        search_results["data"].each do |tweet|
          # 既存のポストをスキップ
          next if Post.exists?(x_post_id: tweet["id"])
          
          # いいね数が10以上のポストのみ取得
          metrics = tweet["public_metrics"]
          next if metrics.nil? || metrics["like_count"].to_i < 10
          
          # 1ヶ月以内のポストのみ取得
          created_at = Time.parse(tweet["created_at"])
          next if created_at < 1.month.ago
          
          # ユーザー情報を取得
          user_info = client.get_user(tweet["author_id"])
          
          if user_info["data"].present?
            # ポストを保存
            post = Post.create(
              x_post_id: tweet["id"],
              content: tweet["text"],
              author_username: user_info["data"]["username"],
              author_name: user_info["data"]["name"],
              likes_count: metrics["like_count"].to_i,
              posted_at: created_at,
              used: false
            )
            
            # キーワードとの関連付け
            post.keywords << keyword
            
            posts_count += 1
          end
        end
      end
    end
    
    render json: { success: true, posts_count: posts_count }
  end
end
