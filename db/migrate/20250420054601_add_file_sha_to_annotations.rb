class AddFileShaToAnnotations < ActiveRecord::Migration[7.2]
  def change
    add_column :annotations, :file_sha, :string
  end
end
