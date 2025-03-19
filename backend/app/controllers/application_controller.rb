class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      # 環境変数から認証情報を取得
      ActiveSupport::SecurityUtils.secure_compare(username, ENV['BASIC_AUTH_USERNAME'] || 'admin') &&
      ActiveSupport::SecurityUtils.secure_compare(password, ENV['BASIC_AUTH_PASSWORD'] || 'password')
    end
  end
end
