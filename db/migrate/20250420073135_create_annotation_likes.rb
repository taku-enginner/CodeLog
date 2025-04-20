class CreateAnnotationLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :annotation_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :annotation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
