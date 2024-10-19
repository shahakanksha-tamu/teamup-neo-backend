class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :contact, limit: 10
      t.integer :role, default: 0
      t.string :photo, limit: 255
      t.string :provider, default: "google_oauth2"
      t.timestamps
      t.index :email, unique: true, name: 'index_users_on_email_unique'
    end
  end
end
