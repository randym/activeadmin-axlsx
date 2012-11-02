# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
  users = ["Jimi Hendrix", "Jimmy Page", "Yngwie Malmsteen", "Eric Clapton", "Kirk Hammett"].collect do |name|
    first, last = name.split(" ")
    User.create!  :first_name => first,
                  :last_name => last,
                  :username => [first,last].join('-').downcase,
                  :age => rand(80)
  end

  categories = ["Rock", "Pop Rock", "Alt-Country", "Blues", "Dub-Step"].collect do |name|
    Category.create! :name => name
  end

  published_at_values = [Time.now.utc - 5.days, Time.now.utc - 1.day, nil, Time.now.utc + 3.days]

  1_000.times do |i|
    user = users[i % users.size]
    cat = categories[i % categories.size]
    published_at = published_at_values[i % published_at_values.size]
    Post.create :title => "Blog Post #{i}",
                :body => "Blog post #{i} is written by #{user.username} about #{cat.name}",
                :category => cat,
                :published_at => published_at,
                :author => user
  end
