class RemoveLineNumberFromAnnotations < ActiveRecord::Migration[7.2]
  def change
    remove_column :annotations, :line_number, :integer
  end
end
