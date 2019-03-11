class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.integer :alumnus_id
      t.integer :event_id
      t.string :description
      t.timestamps
    end

    add_index :attendances, :alumnus_id
    add_index :attendances, :event_id
    add_index :attendances, [:alumnus_id, :event_id], unique: true
  end
end
