# CREATE Admins
puts "BEGIN: Create admins"
admins = [
  { email: "wrburgess@gmail.com", username: "wrburgess", first_name: "Randy", last_name: "Burgess" },
  { email: "angeleah@gmail.com", username: "angeleah", first_name: "Angeleah", last_name: "Daidone" },
]
admins.each do |admin|
  User.seed_admin(admin)
end
puts "END:   Create Admins, Admin Count: #{User.admins.count}"

# CREATE Customers
if User.dummies.count < 1000
  puts "BEGIN: Create users"
  10.times.each do
    User.seed(roles: [UserRoles::CUSTOMER])
  end
  puts "END:   Create Users, Dummy User Count: #{User.dummies.count}"
end

# CREATE Addresses
if Address.dummies.count < 1000
  puts "BEGIN: Create addresses"
  User.dummies.each do |user|
    10.times.each do
      Address.seed(author: user)
    end
  end
  puts "END:   Create Addresses, Dummy User Count: #{Address.dummies.count}"
end

# CREATE Happenings
if Happening.dummies.count < 1000
  puts "BEGIN: Create Happenings"
  User.dummies.each do |user|
    10.times.each do
      Happening.seed(author: user)
    end
  end
  puts "END:   Create Happenings, Dummy User Count: #{Happening.dummies.count}"
end

# CREATE Occurrences
if Occurrence.dummies.count < 1000
  puts "BEGIN: Create Occurrences"
  Happening.dummies.each do |happening|
    10.times.each do
      Occurrence.seed(happening: happening)
    end
  end
  puts "END:   Create Occurrences, Dummy User Count: #{Occurrence.dummies.count}"
end
