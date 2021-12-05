# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Rol.create([{name:"Administración"}])
Rol.create ([{name:"Consulta"}])
Rol.create([{name: "Asistencia"}])

User.create([{email: 'admin@gmail.com', password: 'admin123', password_confirmation: 'admin123', rol_id: 1 }])
User.create([{email: 'consul@gmail.com', password: 'consul123', password_confirmation: 'consul123', rol_id: 2 }])
User.create([{email: 'asis@gmail.com', password: 'asis123', password_confirmation: 'asis123', rol_id: 3}])

for i in 1..15 do 
    p = Professional.create(name:"name-#{i}" ,surname:"surname-#{i}")
    for j in (1..40) do
        hour= rand(8..21)
        date =  (rand(DateTime.now..(DateTime.now + 40))).strftime("%F_#{hour}:00")
        date = DateTime.parse(date)
        Appointment.create(date:date, name:"name-#{i}-#{j}", surname:"surname-#{i}-#{j}", phone:(rand(221000000..2219999999)), notes:"pureba#{i}-#{j}", professional_id:p.id)
    end
end