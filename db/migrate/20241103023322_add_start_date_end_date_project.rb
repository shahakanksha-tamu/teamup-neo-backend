class AddStartDateEndDateProject < ActiveRecord::Migration[7.2]
  def change
    rename_column :projects, :timeline, :end_date
    add_column :projects, :start_date, :datetime
  end
end
