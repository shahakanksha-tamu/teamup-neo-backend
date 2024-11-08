class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.boolean :show
      t.timestamps
    end
  end
end
