class AddScoreToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :score, :float
  end
end
