class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def require_role(roles)
    unless roles.include?(session[:role])
      flash[:alert] = "You do not have access to the page"
      redirect_to root_path
    end
  end
end
