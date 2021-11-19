# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Rol.create([name: "admin"])
Rol.create([name:"consultation"])
Rol.create([name:"attendance"])
User.create([{email: 'admin@gmail.com', password: 'admin123', password_confirmation: 'admin123', rol_id: 1 }])
User.create([{email: 'consultation@gmail.com', password: 'consultation123', password_confirmation: 'consultation123', rol_id: 2 }])
User.create([{email: 'attendance@gmail.com', password: 'attendance123', password_confirmation: 'attendance123', rol_id: 3}])