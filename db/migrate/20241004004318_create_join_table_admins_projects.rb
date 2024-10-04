class CreateJoinTableAdminsProjects < ActiveRecord::Migration[7.2]
  def change
    create_join_table :admins, :projects do |t|
      # t.index [:admin_id, :project_id]
      # t.index [:project_id, :admin_id]
    end
  end
end
