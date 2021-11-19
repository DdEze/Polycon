class AddProfessionalIdToAppointments < ActiveRecord::Migration[6.1]
  def change
    #add_reference :appointments, :professional, null: false, foreign_key: true
  end
end
