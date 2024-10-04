class CreateJoinTableStudentsProjects < ActiveRecord::Migration[7.2]
  def change
    create_join_table :students, :projects do |t|
      # t.index [:student_id, :project_id]
      # t.index [:project_id, :student_id]
    end
  end
end
