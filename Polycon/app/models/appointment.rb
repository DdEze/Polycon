class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, :name, :surname, :phone, presence: true
  validates :name, :surname, length: { maximum: 30 }
  validates :date, uniqueness: {
      scope: :professional_id,
      message: "Ya existe este turno" }
  validates :phone, numericality:{
    only_integer: true}, length: { in: 8..15 }
  validates_date :date, on_or_after: lambda {DateTime.tomorrow}, on_or_after_message: "La fecha debe ser a partir del #{DateTime.tomorrow}", between: ['8:00am', '9:00pm']

  def date_format
    date.strftime("%F %R")
  end

  def date_hour
    date.strftime("%R")
  end

  def data_professional
    "#{professional.surname} #{professional.name}"
  end

end
