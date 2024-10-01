
  users = [
    { first_name: "Akanksha", last_name: "Shah", email: "shahakanksha@tamu.edu", role: "admin" },
    { first_name: "Rahaan", last_name: "Gandhi", email: "Rahaang99@tamu.edu", role: 0 },
    { first_name: "Dhruva", last_name: "Khanwelkar", email: "Dhruvak@tamu.edu", role: 0 },
    { first_name: "Meghana", last_name: "Pradhan", email: "meghna.pradhan@tamu.edu", role: 0 },
    { first_name: "Ramneek", last_name: "Kaur", email: "ramneek983@tamu.edu", role: 0 },
    { first_name: "Hao", last_name: "Jin", email: "q389974204@tamu.edu", role: 0 },
    { first_name: "Yiyang", last_name: "Yan", email: "yyy2000@tamu.edu", role: 0 }
  ]

  users.each do |user|
    User.find_or_create_by!(user)
  end
