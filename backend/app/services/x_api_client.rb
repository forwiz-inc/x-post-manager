require 'net/http'
require 'uri'
require 'json'

class XApiClient
  def initialize
    @client_id = ENV['X_CLIENT_ID']
    @client_secret = ENV['X_CLIENT_SECRET']
    @bearer_token = ENV['X_BEARER_TOKEN']
  end

  def search_posts(keyword, count = 20) 
    uri = URI.parse("https://api.twitter.com/2/tweets/search/recent") 
    params = {
      query: "#{keyword} -is:retweet -has:links -has:media lang:ja",
      max_results: count,
      "tweet.fields": "created_at,public_metrics,author_id"
    }
    uri.query = URI.encode_www_form(params)

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{@bearer_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request) 
    end

    JSON.parse(response.body)
  end

  def get_user(user_id)
    uri = URI.parse("https://api.twitter.com/2/users/#{user_id}") 
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{@bearer_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request) 
    end

    JSON.parse(response.body)
  end

  def post_tweet(text)
    uri = URI.parse("https://api.twitter.com/2/tweets") 
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@bearer_token}"
    request["Content-Type"] = "application/json"
    request.body = { text: text }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request) 
    end

    JSON.parse(response.body)
  end
end
