class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, :name, :surname, :phone, presence: true
  validates :date, uniqueness: {
      scope: :professional_id,
      message: "Ya existe este turno" }

  def date_format
    date.strftime("%F %R")
  end
end
