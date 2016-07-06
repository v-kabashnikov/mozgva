puts 'creating users'
User.create(email: 'admin@mozgva.ru', password: 'password', name: 'Админ', role: 'admin')
User.create(email: 'moderator@mozgva.ru', password: 'password', name: 'Модератор', role: 'moderator')
User.create(email: 'user@mozgva.ru', password: 'password', name: 'Юзер')