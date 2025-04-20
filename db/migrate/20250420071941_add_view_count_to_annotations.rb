class AddViewCountToAnnotations < ActiveRecord::Migration[7.2]
  def change
    add_column :annotations, :view_count, :integer, default: 0, null: false
  end
end
