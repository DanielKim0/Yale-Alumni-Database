class CreateAlumniEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :alumni_events do |t|
      t.string :alumni
      t.string :events
    end
  end
end
