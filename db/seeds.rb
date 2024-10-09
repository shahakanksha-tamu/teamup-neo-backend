# frozen_string_literal: true

users = [
  { first_name: 'Akanksha', last_name: 'Shah', email: 'shahakanksha@tamu.edu', role: 'admin' },
  { first_name: 'Rahaan', last_name: 'Gandhi', email: 'rahaang99@tamu.edu', role: 0 },
  { first_name: 'Dhruva', last_name: 'Khanwelkar', email: 'dhruvak@tamu.edu', role: 0 },
  { first_name: 'Meghana', last_name: 'Pradhan', email: 'meghna.pradhan@tamu.edu', role: 0 },
  { first_name: 'Ramneek', last_name: 'Kaur', email: 'ramneek983@tamu.edu', role: 0 },
  { first_name: 'Hao', last_name: 'Jin', email: 'q389974204@tamu.edu', role: 0 },
  { first_name: 'Yiyang', last_name: 'Yan', email: 'yyy2000@tamu.edu', role: 0 },
  { first_name: 'Florencia', last_name: 'Mangini', email: 'florencia.mangini@teamup.org', role: 'admin' },
  { first_name: 'David', last_name: 'Kebo', email: 'davidkebo@tamu.edu', role: 'admin' },
  { first_name: 'Shashankit', last_name: 'Thakur', email: 'shashankit.thakur@gmail.com', role: 'admin' }
]

users.each do |user|
  User.find_or_create_by!(user)
end
