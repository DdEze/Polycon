class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :rol
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :rol_id, presence: true
end