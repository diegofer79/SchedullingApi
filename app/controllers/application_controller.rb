class ApplicationController < ActionController::API
  before_action :deny_access, :unless => :authenticated?

  def authenticated?
    params[:validation_key] == Rails.configuration.api_key ||
    session[:validation_key] == Rails.configuration.api_key
  end
  
  def deny_access
    return render json: {error: "Unauthorized"}, status: :unauthorized
  end
end
