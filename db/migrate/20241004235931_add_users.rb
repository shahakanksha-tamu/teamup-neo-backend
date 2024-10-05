class AddUsers < ActiveRecord::Migration[7.2]
  def up
    User.create(first_name: 'Phillip', last_name:'Ritchey', email: 'pcr@tamu.edu', role: 0)
    User.create(first_name: 'Anirith', last_name:'', email: 'anirith@tamu.edu', role: 0)
  end
end
