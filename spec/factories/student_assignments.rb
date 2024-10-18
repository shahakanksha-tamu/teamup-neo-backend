# spec/factories/student_assignments.rb
FactoryBot.define do
  factory :student_assignment do
    association :project  # This assumes a `project` association exists in the `StudentAssignment` model
    association :student, factory: :user  # Assuming `student` is a `User` with a specific role

    # Optionally, if you want to ensure the student has a specific role (e.g., 'student')
    after(:build) do |student_assignment|
      student_assignment.student ||= create(:user, role: 'student')  # Adjust according to your role setup
    end
  end
end
