class Api::V1::KeywordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_keyword, only: [:show, :update, :destroy]

  # GET /api/v1/keywords
  def index
    keywords = Keyword.all
    render json: keywords
  end

  # GET /api/v1/keywords/:id
  def show
    render json: @keyword
  end

  # POST /api/v1/keywords
  def create
    keyword = Keyword.new(keyword_params)

    if keyword.save
      render json: keyword, status: :created
    else
      render json: { error: keyword.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/keywords/:id
  def update
    if @keyword.update(keyword_params)
      render json: @keyword
    else
      render json: { error: @keyword.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/keywords/:id
  def destroy
    @keyword.destroy
    head :no_content
  end

  private
  
  def set_keyword
    @keyword = Keyword.find(params[:id])
  end
  
  def keyword_params
    params.require(:keyword).permit(:word, :active)
  end
end
