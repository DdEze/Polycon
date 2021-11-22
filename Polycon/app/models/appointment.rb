class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, :name, :surname, :phone, presence: true
  validates :date, uniqueness: {
      scope: :professional_id,
      message: "Ya existe este turno" }
  validates :phone, numericality:{
    only_integer: true}

  def date_format
    date.strftime("%F %R")
  end

  def date_hour
    date.strftime("%R")
  end

  def data_professional
    Professional.find(professional_id).surname_and_name
  end

end
