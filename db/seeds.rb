# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


CSV.foreach('db/recent_init.csv') do |row|
  #youkeisai

  RecentCabbage.create(date: row[0], price: row[1])
  PastCabbage.create(date: row[0], price: row[1])

  RecentNegi.create(date: row[0], price: row[1])
  PastNegi.create(date: row[0], price: row[1])

  RecentHakusai.create(date: row[0], price: row[1])
  PastHakusai.create(date: row[0], price: row[1])

  RecentSpinach.create(date: row[0], price: row[1])
  PastSpinach.create(date: row[0], price: row[1])

  RecentLettuce.create(date: row[0], price: row[1])
  PastLettuce.create(date: row[0], price: row[1])

  RecentOnion.create(date: row[0], price: row[1])
  PastOnion.create(date: row[0], price: row[1])

  RecentBroccoli.create(date: row[0], price: row[1])
  PastBroccoli.create(date: row[0], price: row[1])

  #kasai
  RecentCucumber.create(date: row[0], price: row[1])
  PastCucumber.create(date: row[0], price: row[1])

  RecentTomato.create(date: row[0], price: row[1])
  PastTomato.create(date: row[0], price: row[1])

  RecentEggplant.create(date: row[0], price: row[1])
  PastEggplant.create(date: row[0], price: row[1])

  RecentPeeman.create(date: row[0], price: row[1])
  PastPeeman.create(date: row[0], price: row[1])

  #konsai
  RecentDaikon.create(date: row[0], price: row[1])
  PastDaikon.create(date: row[0], price: row[1])

  RecentCarrot.create(date: row[0], price: row[1])
  PastCarrot.create(date: row[0], price: row[1])

  #imo
  RecentTaro.create(date: row[0], price: row[1])
  PastTaro.create(date: row[0], price: row[1])

  RecentPotato.create(date: row[0], price: row[1])
  PastPotato.create(date: row[0], price: row[1])

end


CSV.foreach('db/recipe_category.csv') do |row|
  Category.create(category_id: row[1], name: row[0])
end
