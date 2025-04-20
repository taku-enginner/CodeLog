class CreateAnnotationTags < ActiveRecord::Migration[7.2]
  def change
    create_table :annotation_tags do |t|
      t.references :annotation, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
