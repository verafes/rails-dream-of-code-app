class AdminDashboardController < ApplicationController
  def index
    @current_trimester = Trimester.where(
        "start_date <= ?", Date.today).where("end_date >= ?", Date.today
        ).first
    @upcoming_trimester = Trimester.where(
        "start_date > ? AND start_date <= ?", Date.today,  6.months.from_now
        ).order(:start_date)
         .first    
  end
end