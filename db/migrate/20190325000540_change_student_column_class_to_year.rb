class ChangeStudentColumnClassToYear < ActiveRecord::Migration[5.2]
  def change
    rename_column :students, :class, :year
  end
end
