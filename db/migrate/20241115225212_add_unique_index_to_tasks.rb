class AddUniqueIndexToTasks < ActiveRecord::Migration[7.2]
  def change
        add_index :tasks, [:task_name, :milestone_id], unique: true, name: 'index_tasks_on_task_name_and_milestone_id'

  end
end
