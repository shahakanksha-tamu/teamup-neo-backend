class CreateTaskAssignments < ActiveRecord::Migration[7.2]
    def change
      create_table :task_assignments do |t|
        t.references :user, foreign_key: true
        t.references :task, foreign_key: true
        t.timestamps
      end
    end
  end
  