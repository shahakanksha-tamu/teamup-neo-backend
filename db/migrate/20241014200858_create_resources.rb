class CreateResources < ActiveRecord::Migration[7.2]
  def change
    create_table :resources do |t|
      t.timestamps
    end
  end
end
