class CreateAlumni < ActiveRecord::Migration[5.2]
  def change
    create_table :alumni do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :location
      t.string :college
      t.string :yale_degree
      t.integer :yale_degree_year
      t.string :other_degrees
      t.string :linkedin
      t.string :employer
      t.string :employed_field
      t.string :recommender

      t.timestamps
    end
  end
end
