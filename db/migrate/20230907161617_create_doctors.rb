class CreateDoctors < ActiveRecord::Migration[7.0]
  def up
    create_table :doctors do |t|
      t.string :full_name, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end

  def down
    drop_table :doctors
  end
end
