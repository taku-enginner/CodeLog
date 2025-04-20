class AddTagsToAnnotations < ActiveRecord::Migration[7.2]
  def change
    add_column :annotations, :tags, :string
  end
end
