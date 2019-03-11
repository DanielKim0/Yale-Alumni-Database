class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :month
      t.integer :year
      t.string :description
      t.boolean :CLY_sponsored
      t.string :location

      t.timestamps
    end
  end
end
