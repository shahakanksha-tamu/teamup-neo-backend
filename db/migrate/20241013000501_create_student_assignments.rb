class CreateStudentAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :student_assignments do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.timestamps
    end

    # Add the index after the table has been created
    add_index :student_assignments, [:user_id, :project_id], unique: true
  end
end
  