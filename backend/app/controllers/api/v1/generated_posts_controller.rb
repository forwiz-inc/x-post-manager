class Api::V1::GeneratedPostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_generated_post, only: [:show, :update, :destroy]

  # GET /api/v1/generated_posts
  def index
    if params[:post_id]
      generated_posts = GeneratedPost.where(original_post_id: params[:post_id])
    else
      generated_posts = GeneratedPost.all
    end
    
    render json: generated_posts
  end

  # GET /api/v1/generated_posts/:id
  def show
    render json: @generated_post
  end

  # POST /api/v1/generated_posts
  def create
    generated_post = GeneratedPost.new(generated_post_params)

    if generated_post.save
      render json: generated_post, status: :created
    else
      render json: { error: generated_post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/generated_posts/:id
  def update
    if @generated_post.update(generated_post_params)
      render json: @generated_post
    else
      render json: { error: @generated_post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/generated_posts/:id
  def destroy
    @generated_post.destroy
    head :no_content
  end

  private
  
  def set_generated_post
    @generated_post = GeneratedPost.find(params[:id])
  end
  
  def generated_post_params
    params.require(:generated_post).permit(:original_post_id, :content, :posted, :posted_at)
  end
end
