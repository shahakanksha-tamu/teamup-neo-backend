class AddNameAndProjectToResources < ActiveRecord::Migration[7.2]
  def change
    add_column :resources, :name, :string
    add_reference :resources, :project, null: false, foreign_key: true
  end
end
