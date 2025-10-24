class SessionsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      # Let's set user_id and also role
      session[:user_id] = user.id
      session[:role] = user.role
      # redirect_to root_path

      if request.format.json?
        render json: { message: "Logged in", user_id: user.id, role: user.role }  
      else
        flash.now[:alert] = 'Logged in successfully!'
        redirect_to root_path
      end
    else
      if request.format.json?
        render json: { error: "Invalid username or password" }, status: :unauthorized
      else  
        flash.now[:alert] = 'Invalid username or password.'
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:role] = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end
end