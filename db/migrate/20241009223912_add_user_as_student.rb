class AddUserAsStudent < ActiveRecord::Migration[7.2]
  def up
    User.create(first_name: 'Shashankit', last_name: 'Thakur', email: 'shashankit.t@gmail.com', role: 'admin')
  end
end
