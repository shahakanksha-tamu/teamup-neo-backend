class AddUniqueIndexToProjectsName < ActiveRecord::Migration[7.2]
  def change
    add_index :projects, :name, unique: true
  end
end
