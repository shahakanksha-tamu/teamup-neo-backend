class AddMaxScoreToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :max_score, :float
  end
end
