class AddNamesToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :first_name, :string
    add_column :students, :last_name, :string
  end
end
