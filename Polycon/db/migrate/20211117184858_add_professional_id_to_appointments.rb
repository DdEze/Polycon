class AddProfessionalIdToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :professional, :reference
  end
end
