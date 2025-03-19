require 'twitter_oauth2'
require 'net/http'
require 'json'

class XApiClient
  def initialize
    @client_id = ENV['X_CLIENT_ID']
    @client_secret = ENV['X_CLIENT_SECRET']
    @bearer_token = ENV['X_BEARER_TOKEN']
    @callback_url = ENV['X_CALLBACK_URL']
  end

  # X APIを使用してポストを検索する
  def search_posts(keywords, count = 20)
    # キーワードを組み合わせてクエリを作成
    query = keywords.join(' OR ')
    
    # APIリクエストのためのURI作成
    uri = URI("https://api.twitter.com/2/tweets/search/recent")
    params = {
      'query' => "#{query} -is:retweet -has:links -has:media lang:ja",
      'max_results' => count,
      'tweet.fields' => 'created_at,public_metrics,author_id',
      'user.fields' => 'name,username',
      'expansions' => 'author_id'
    }
    uri.query = URI.encode_www_form(params)
    
    # リクエスト作成
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@bearer_token}"
    
    # リクエスト送信
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    # レスポンス解析
    if response.code == '200'
      JSON.parse(response.body)
    else
      { error: "API request failed with status #{response.code}", details: response.body }
    end
  end

  # X APIを使用してポストを投稿する
  def post_tweet(content)
    # OAuth2クライアント作成
    client = TwitterOAuth2::Client.new(
      identifier: @client_id,
      secret: @client_secret,
      redirect_uri: @callback_url
    )
    
    # アクセストークンを使用してツイート投稿
    # 注: 実際の実装ではアクセストークンの取得と保存のロジックが必要
    # このサンプルコードでは、アクセストークンがすでに取得済みと仮定
    access_token = session[:access_token] # 実際の実装ではセッションやDBから取得
    
    # ツイート投稿APIエンドポイント
    uri = URI("https://api.twitter.com/2/tweets")
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{access_token}"
    request['Content-Type'] = 'application/json'
    request.body = { text: content }.to_json
    
    # リクエスト送信
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    # レスポンス解析
    if response.code == '201'
      JSON.parse(response.body)
    else
      { error: "Tweet posting failed with status #{response.code}", details: response.body }
    end
  end
  
  # OAuth2認証URLを生成
  def authorization_url
    client = TwitterOAuth2::Client.new(
      identifier: @client_id,
      secret: @client_secret,
      redirect_uri: @callback_url
    )
    
    client.authorization_uri(
      scope: ['tweet.read', 'tweet.write', 'users.read', 'offline.access']
    )
  end
  
  # コールバックからアクセストークンを取得
  def get_access_token(code)
    client = TwitterOAuth2::Client.new(
      identifier: @client_id,
      secret: @client_secret,
      redirect_uri: @callback_url
    )
    
    client.authorization_code = code
    token = client.access_token!
    
    {
      access_token: token.access_token,
      refresh_token: token.refresh_token,
      expires_at: Time.now + token.expires_in
    }
  end
end
