# Question 1

# create a new spring trimester
Course.column_names
Trimester.create(
  year: '2026',
  term: 'Spring',
  application_deadline: '2026-02-15',
  start_date: '2026-03-01',
  end_date: '2026-06-30'
)

# confirm if it was created
spring2026 = Trimester.find_by(year: '2026', term: 'Spring')
puts spring2026.id ? spring2026.id : "Spring 2026 trimester not found."

spring2026.year
spring2026.term
spring2026.application_deadline
spring2026.start_date
spring2026.end_date

# get classes
CodingClass.column_names
coding_classes = CodingClass.all
coding_classes.each { |cc| puts "#{cc.id} | #{cc.title}" }

# courses for the Spring 2026 trimester
CodingClass.all.each do |coding_class|
    existing = Course.find_by(coding_class_id: coding_class.id, trimester_id: spring2026.id)
    unless existing
        course = Course.create(
            coding_class_id: coding_class.id, 
            trimester_id: spring2026.id, 
            max_enrollment: 25
        )

    if course.valid?
    course.save
    else
        puts "Validation failed for #{coding_class.title}: #{course.errors.full_messages.join(", ")}"
    end
  end
end

# confirm with count courses
Course.where(trimester_id: spring2026.id).count # 5

# Question 2
# Create a new student record and enroll the student in the Intro to Programming course for the Spring 2026 trimester.
Student.column_names
student = Student.find_by(email: "alice@example.com")
if student
  puts "Student #{student.first_name} already exists (ID: #{student.id})"
else  
  student = Student.create(
    first_name: "Alice",
    last_name: "Williams",
    email: "alice@example.com"
  )
  raise "Student creation failed" unless student.persisted?
end

spring2026 = Trimester.find_by(year: '2026', term: 'Spring') 
intro_class = CodingClass.find_by(title: 'Intro to Programming')
course = Course.find_by(coding_class_id: intro_class.id, trimester_id: spring2026.id)
raise "No intro course found for spring 2026 trimester and coding class" unless course

Enrollment.column_names

if spring2026 && intro_class && course
  enrollment = Enrollment.find_by(course_id: course.id, student_id: student.id) || 
               Enrollment.new(course_id: course.id, student_id: student.id)
  raise "Enrollment creation failed" unless enrollment.save
  puts "Enrollment ID: #{enrollment.id}, Student: #{enrollment.student.first_name}"
end

# confirm enrolment
Enrollment.find_by(student_id: student.id, course_id: course.id)
puts "Student #{student.first_name} enrolled in #{course.coding_class.title} for Spring 2026"

# check tables and colomns
Mentor.column_names
MentorEnrollmentAssignment.column_names

# Find a mentor with ≤ 2 enrollments
mentor = Mentor.all.find do |m|
  mentor_assignments = MentorEnrollmentAssignment.where(mentor_id: m.id).count
  puts "#{m.first_name} #{m.last_name} has #{mentor_assignments} mentor assignments"
  mentor_assignments <= 2
end

# assign the mentor (if found) to the new student
if mentor
  existing_assignment = MentorEnrollmentAssignment.find_by(enrollment_id: enrollment.id)

  if existing_assignment
    assigned_mentor = Mentor.find(existing_assignment.mentor_id)
    puts "Mentor #{assigned_mentor.first_name} #{assigned_mentor.last_name} already assigned to #{student.first_name} enrollment "
  else
    assignment = MentorEnrollmentAssignment.create(
      mentor_id: mentor.id,
      enrollment_id: enrollment.id
    )

    if assignment.persisted?
      puts "Mentor #{mentor.first_name} #{mentor.last_name} is assigned to student #{student.first_name}"
    else
      puts "Mentor assignment failed: #{assignment.errors.full_messages.join(", ")}"
    end
  end
else
  puts "No available mentor with ≤ 2 enrollments"
end
