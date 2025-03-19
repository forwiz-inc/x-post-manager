class Api::V1::PostsController < ApplicationController
  def index
    @posts = Post.where(used: false) .order(posted_at: :desc).limit(20)
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def transform
    @post = Post.find(params[:id])
    transformed_content = transform_content(@post.content)
    
    render json: { original_content: @post.content, transformed_content: transformed_content }
  end

  def post_to_x
    @post = Post.find(params[:id])
    content = params[:content]
    
    # X APIを使用して投稿
    client = XApiClient.new
    result = client.post_tweet(content)
    
    if result["data"] && result["data"]["id"]
      # 投稿成功
      @generated_post = @post.generated_posts.create(
        content: content,
        posted: true,
        posted_at: Time.current
      )
      
      # 元のポストを使用済みにマーク
      @post.update(used: true)
      
      render json: { success: true, post: @generated_post }
    else
      # 投稿失敗
      render json: { success: false, error: result["errors"] || "投稿に失敗しました" }, status: :unprocessable_entity
    end
  end

  private

  def transform_content(original_content)
    # TextTransformServiceを使用してテキスト変換
    TextTransformService.transform_content(original_content)
  end
end
