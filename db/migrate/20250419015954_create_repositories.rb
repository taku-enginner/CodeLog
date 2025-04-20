class CreateRepositories < ActiveRecord::Migration[7.2]
  def change
    create_table :repositories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :full_name
      t.string :github_token

      t.timestamps
    end
  end
end
