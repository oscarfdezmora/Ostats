# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
mem = Member.new(:username => "aljesusg", :email => "aljesusg@gmail.com", :user_id => 9035107, :is_permit => true, :is_admin => true,:thumb => "https://plex.tv/users/6f7bea5492714840/avatar?c=2017-03-20+19%3A06%3A31+UTC")
mem.save
