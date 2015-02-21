class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  helper_method :current_user, :current_user_is_member_of_club, :is_admin

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def is_admin
    return false unless current_user
    current_user.admin
  end

  def current_user_is_member_of_club(beer_club)
    return false unless current_user

    return beer_club.members.include?(current_user)
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    redirect_to root_path, notice:'This action is reserved for admins' unless is_admin
  end


end
