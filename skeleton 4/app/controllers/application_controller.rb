class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def login!(user)
    session[:session_token] = user.session_token
  end

  def logout!
    session[:session_token] = nil
    current_user.reset_session_token!
  end

  def current_user
    @user ||= User.find_by(session_token: session[:session_token])
  end

  def require_logged_out
    redirect_to cats_url if logged_in?
  end


  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def ensure_owns_cat
    unless Cat.find(params[:id]).user_id == current_user.id
      redirect_to cats_url
    end
  end

end
