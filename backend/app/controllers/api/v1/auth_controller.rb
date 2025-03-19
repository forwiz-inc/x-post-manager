class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate, only: [:callback]
  skip_before_action :verify_authenticity_token

  # GET /api/v1/auth/authorize
  def authorize
    x_client = XApiClient.new
    authorization_url = x_client.authorization_url
    render json: { authorization_url: authorization_url }
  end

  # GET /api/v1/auth/callback
  def callback
    code = params[:code]
    
    if code.blank?
      render json: { error: "認証コードが見つかりません" }, status: :bad_request
      return
    end
    
    x_client = XApiClient.new
    token_info = x_client.get_access_token(code)
    
    # 実際の実装ではトークン情報をDBに保存するなどの処理が必要
    # このサンプルではセッションに保存
    session[:access_token] = token_info[:access_token]
    session[:refresh_token] = token_info[:refresh_token]
    session[:expires_at] = token_info[:expires_at]
    
    # フロントエンドにリダイレクト
    redirect_to ENV['FRONTEND_URL'] || 'http://localhost:3001'
  end

  # GET /api/v1/auth/status
  def status
    if session[:access_token].present? && session[:expires_at].present? && Time.parse(session[:expires_at].to_s) > Time.current
      render json: { authenticated: true, expires_at: session[:expires_at] }
    else
      render json: { authenticated: false }
    end
  end
end
