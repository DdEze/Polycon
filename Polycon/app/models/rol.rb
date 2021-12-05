class Rol < ApplicationRecord
    validates :name, presence: true, uniqueness: true
end
