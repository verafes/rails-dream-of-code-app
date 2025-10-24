class HomeController < ApplicationController
  def index
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      if user
        case user.role
        when "mentor"
          mentor = Mentor.find_by(email: user.username)
          redirect_to mentor_path(mentor) and return if mentor
        when "student"
          student = Student.find_by(email: user.username)
          redirect_to student_path(student) and return if student
        when "admin"
          redirect_to dashboard_path and return
        end
      end
    end
  end
end

