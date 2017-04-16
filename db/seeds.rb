# CREATE Admins
puts "BEGIN: Create admins"
admins = [
  { email: "wrburgess@gmail.com", username: "wrburgess", first_name: "Randy", last_name: "Burgess" },
  { email: "angeleah@gmail.com", username: "angeleah", first_name: "Angeleah", last_name: "Daidone" },
]
admins.each do |admin|
  User.seed_admin(admin)
end
puts "END:   Create admins, Admin Count: #{User.admins.count}"

# CREATE Customers
if User.dummies.count < 1000
  puts "BEGIN: Create users"
  10.times.each do
    User.seed(roles: [UserRoles::CUSTOMER], dummy: true)
  end
  puts "END:   Create users, Dummy User Count: #{User.dummies.count}"
end
