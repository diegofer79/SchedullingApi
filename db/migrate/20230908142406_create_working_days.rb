class CreateWorkingDays < ActiveRecord::Migration[7.0]
  def up
    create_table :working_days do |t|
      t.integer :doctor_id, null: false
      t.integer :weekday, null: false
      t.string :start_working_hour
      t.string :end_working_hour
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :working_days, :doctor_id
  end

  def down
    drop_table :working_days
  end
end
