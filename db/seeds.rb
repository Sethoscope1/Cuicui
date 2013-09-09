# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


clem = User.create!({:twitter_user_id => "3", :screen_name => "Clementpigeon2"})
seth = User.create!({:twitter_user_id => "4", :screen_name => "sethypants2"})


tweet1 = Status.create!({:twitter_status_id => "4", :twitter_user_id => "1", :body => "I love cheese"})
tweet2 = Status.create!({:twitter_status_id => "5", :twitter_user_id => "1", :body => "I need a notary"})
tweet3 = Status.create!({:twitter_status_id => "6", :twitter_user_id => "2", :body => "He needs a printer"})
