class Professional < ApplicationRecord
    has_many :appointments
    validates :name, :surname, presence: true
    validates :name, uniqueness: {
      scope: :surname,
      message: "Ya existe este profesional" }
      
    def surname_and_name
        "#{surname} #{name}"
    end

    def appointment(date)
      app = self.appointments.select {|a| a.date == date}.first
      if app.nil?
        "-----"
      else
        "#{app.surname} #{app.name}"
      end
    end
end