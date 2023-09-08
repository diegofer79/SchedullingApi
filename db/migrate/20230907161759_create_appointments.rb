class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.integer :doctor_id, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.json :patient_info
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :appointments, :doctor_id
  end

  def down
    drop_table :appointments
  end
end
