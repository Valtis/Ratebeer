class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.banned
        redirect_to signin_path, notice: "You have been banhammered, please contact admin team"
      else
        reset_session
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
      end
    else
      redirect_to :back, notice: "Invalid username or password"
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

end

