class AddDescriptionToAlumni < ActiveRecord::Migration[5.2]
  def change
    add_column :alumni, :description, :string
  end
end
