class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.datetime :date, null: false
      t.string :name, null: false
      t.string :surname, null: false
      t.integer :phone, null: false
      t.string :notes, null: false, default: "No hay notas"
      t.belongs_to :professional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
