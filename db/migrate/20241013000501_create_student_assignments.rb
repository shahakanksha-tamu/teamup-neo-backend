class CreateStudentAssignments < ActiveRecord::Migration[7.2]
    def change
      create_table :student_assignments do |t|
        t.references :user, foreign_key: true
        t.references :project, foreign_key: true
        t.timestamps
      end
    end
  end
  