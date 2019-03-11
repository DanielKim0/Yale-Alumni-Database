class CreateJoinTableAlumnusEvent < ActiveRecord::Migration[5.2]
  def change
    create_join_table :alumni, :events do |t|
      t.index [:alumnus_id, :event_id]
    end
  end
end
