class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.text :description
      t.text :objectives
      t.text :timeline
      t.text :key_contacts
      t.boolean :active
      t.text :student_list
      t.text :goals
      t.string :status

      t.timestamps
    end
  end
end
