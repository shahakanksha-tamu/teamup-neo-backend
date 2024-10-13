class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :contact, limit: 10
      t.string :role, default: 'student'
      t.string :photo, limit: 200
      t.timestamps
    end
  end
end
