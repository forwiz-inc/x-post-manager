class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :x_post_id
      t.text :content
      t.string :author_username
      t.string :author_name
      t.integer :likes_count
      t.datetime :posted_at
      t.boolean :used

      t.timestamps
    end
    add_index :posts, :x_post_id, unique: true
  end
end
