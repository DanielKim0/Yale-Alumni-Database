class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.integer :alumni
      t.integer :event
      t.timestamps
    end

    add_index :attendances, :alumni
    add_index :attendances, :event
    add_index :attendances, [:alumni, :event], unique: true
  end
end
