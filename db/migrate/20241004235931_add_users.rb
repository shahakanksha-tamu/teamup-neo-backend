class AddUsers < ActiveRecord::Migration[7.2]
  def up
    User.create(first_name: 'Phillip', last_name:'Ritchey', email: 'pcr@tamu.edu', role: 0)
    User.create(first_name: 'Anirith', last_name:'', email: 'anirith@tamu.edu', role: 0)
    User.create(first_name: 'Florencia', last_name: 'Mangini', email: 'florencia.mangini@teamup.org', role: 'admin')
    User.create(first_name: 'David', last_name: 'Kebo', email: 'davidkebo@tamu.edu', role: 'admin')
    User.create(first_name: 'Shashankit', last_name: 'Thakur', email: 'shashankit.thakur@gmail.com', role: 'admin')
    User.create(first_name: 'Akanksha', last_name: 'Shah', email: 'shahakanksha286@gmail.com', role: 'student')
    User.create(first_name: 'Shashankit', last_name: 'Thakur', email: 'shashankit.t@gmail.com', role: 'student')
  end
end
