class Api::V1::KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all
    render json: @keywords
  end

  def create
    @keyword = Keyword.new(keyword_params)
    
    if @keyword.save
      render json: @keyword, status: :created
    else
      render json: { errors: @keyword.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @keyword = Keyword.find(params[:id])
    
    if @keyword.update(keyword_params)
      render json: @keyword
    else
      render json: { errors: @keyword.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy
    head :no_content
  end

  private

  def keyword_params
    params.require(:keyword).permit(:word, :active)
  end
end
