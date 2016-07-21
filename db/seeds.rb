puts 'destroying users'
User.destroy_all
puts 'creating users'
User.create(email: 'admin@mozgva.ru', password: 'password', name: 'Админ', role: 'admin')
User.create(email: 'moderator@mozgva.ru', password: 'password', name: 'Модератор', role: 'moderator')
User.create(email: 'user@mozgva.ru', password: 'password', name: 'Юзер')

puts 'destroying leagues'
League.destroy_all
puts 'creating leagues'
%w(Юго-Запад Высшая Масляков Топчик).each{ |l| League.create(name: l) }

puts 'destroying cities'
City.destroy_all
puts 'creating cities'
%w(Москва Санкт-Петербург Берлин).each{ |c| City.create(name: c) }

puts 'destroying places'
Place.destroy_all
puts 'creating places'
city = City.where(name: 'Москва').first_or_create
Place.create(name: 'Бар "Colin hall"', site: 'http://coin-hall.ru/', city: city, address: 'Улица Пятницкая, 71/5, строение 2')
Place.create(name: 'Glenuill', site: 'http://facebook.com/pages/glenuill/846619468685308', city: city, address: 'Садовая-Самотечная, 20, стр. 1')
city = City.where(name: 'Санкт-Петербург').first_or_create
Place.create(name: 'Гастропаб "Duo"', site: 'http://www.duobar.ru/', city: city, address: 'Кирочная, 8А')
Place.create(name: 'Кафе "Obed Bufet"', site: 'http://spb.obedbufet.ru/nevsky_centre', city: city, address: 'Невский просп., 114–116, ТЦ «Невский центр», 5 этаж')
city = City.where(name: 'Берлин').first_or_create
Place.create(name: 'Teigwaren', site: 'http://www.teigwaren-berlin.de/', city: city, address: 'Oderberger Straße 41')

puts 'destroying games'
Game.destroy_all
puts 'creating games'
40.times do
	Game.create(
		number: rand(1..400), 
		name: "Игра #{(1..6).map{('а'..'я').to_a.sample}.join}",
		place: Place.all.sample,
		league: League.all.sample,
		price: rand(4..7) * 100,
		when: Time.now + rand(1..3600*24*10),
		status: 'open',
		max_people_number: rand(10..100),
		max_teams_number: rand(5..15)
	)
end

