class AdminDashboardController < ApplicationController
  before_action -> { require_role(['admin']) }

  def index
    @current_trimester = Trimester.where(
        "start_date <= ?", Date.today).where("end_date >= ?", Date.today
        ).first
    @upcoming_trimester = Trimester.where(
        "start_date > ? AND start_date <= ?", Date.today,  6.months.from_now
        ).order(:start_date)
         .first  
    respond_to do |format|
      format.html
      format.json { 
        render json: { 
          current_trimester: @current_trimester, 
          upcoming_trimester: @upcoming_trimester 
          } 
        }
    end  
  end
end