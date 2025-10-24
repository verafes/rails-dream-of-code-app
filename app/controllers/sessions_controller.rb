class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user
      if user.authenticate(params[:password])
        # Let's set user_id and also role
        session[:user_id] = user.id
        session[:role] = user.role
        redirect_to root_path

      else
        flash.now[:alert] = 'Invalid username or password.'
        render :new
      end
    else
      flash.now[:alert] = 'Invalid username or password.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:role] = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end
end