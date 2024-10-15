class CreateMilestones < ActiveRecord::Migration[7.2]
  def change
    create_table :milestones do |t|
      t.references :project, foreign_key: true
      t.string :title
      t.text :objective
      t.datetime :deadline
      t.timestamps
    end
  end
end
  