class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.text :objectives
      t.datetime :timeline
      t.string :status, limit: 10, default: 'active'
      t.timestamps
    end
  end
end
  