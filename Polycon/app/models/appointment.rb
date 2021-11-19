class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, :name, :surname, :phone, presence: true
  validates :date, uniqueness: {
      scope: :professional_id,
      message: "Ya existe este turno" }
  validates :phone, numericality:{
    only_integer: true
  }

  def date_format
    date.strftime("%F %R")
  end

end
