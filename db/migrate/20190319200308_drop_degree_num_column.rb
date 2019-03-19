class DropDegreeNumColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :alumni, :yale_degree_year
  end
end
