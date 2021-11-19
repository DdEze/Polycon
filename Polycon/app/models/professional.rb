class Professional < ApplicationRecord
    has_many :appointments
    validates :name, :surname, presence: true
    validates :name, uniqueness: {
      scope: :surname,
      message: "Ya existe este profesional" }
      
    def surname_and_name
        "#{surname} #{name}"
    end
end
