module ApplicationHelper
  def display_user_info
    return unless session[:user_id]
    user = User.find_by(id: session[:user_id])
    return unless user

    case user.role
    when "mentor"
      mentor = Mentor.find_by(email: user.username)
      ["Welcome, #{mentor&.full_name}!", mentor_path(mentor)]
    when "student"
      student = Student.find_by(email: user.username)
      ["Welcome, #{student&.full_name}!", student_path(student)]
    when "admin"
      ["Welcome, Admin!", dashboard_path]
    end
  end
end
