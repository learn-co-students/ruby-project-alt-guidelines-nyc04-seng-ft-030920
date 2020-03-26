#  Destroys all previous data
User.destroy_all
Restaurant.destroy_all
Reservation.destroy_all

# Generates Users
10.times{User.create(name: Faker::Name.unique.name)}

# Generates Restaurants
10.times{Restaurant.create(name: Faker::Restaurant.name, password: "food")}
# Note- we can later user Faker::Restaurant.type to search by restaurant type

# Generates taken Reservations up to 23 days in the future
10.times do
    rand_datetime = Faker::Time.forward(days: 23 , period: :evening)
    Reservation.create(restaurant_id: rand(10) + 1 , user_id: rand(10) + 1 , table_size: rand(8) + 1, datetime: Time.at(rand_datetime).strftime("%B %e, %Y at %I:%M %p"))
end

# Generates open Reservations up to 23 days in the future
10.times do
    rand_datetime = Faker::Time.forward(days: 23 , period: :evening)
    Reservation.create(restaurant_id: rand(10) + 1 , user_id: nil , table_size: rand(8) + 1, datetime: Time.at(rand_datetime).strftime("%B %e, %Y at %I:%M %p"))
end

puts "Seed data initialized!"