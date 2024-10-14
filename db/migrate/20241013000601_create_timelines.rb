class CreateTimelines < ActiveRecord::Migration[7.2]
  def change
    create_table :timelines do |t|
      t.references :milestone, foreign_key: true
      t.references :project, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.text :description
      t.timestamps
    end
  end
end
  