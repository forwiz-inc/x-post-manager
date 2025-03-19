class CreatePostKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :post_keywords do |t|
      t.references :post, null: false, foreign_key: true
      t.references :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
