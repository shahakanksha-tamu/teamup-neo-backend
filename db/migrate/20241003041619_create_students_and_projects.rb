class CreateStudentsAndProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :students_and_projects do |t|
      t.references :project, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
