class CreateTasks < ActiveRecord::Migration[7.2]
    def change
      create_table :tasks do |t|
        t.references :milestone, foreign_key: true
        t.string :task_name, limit: 255
        t.text :description
        t.string :status, limit: 20
        t.datetime :deadline
        t.timestamps
      end
    end
  end
  