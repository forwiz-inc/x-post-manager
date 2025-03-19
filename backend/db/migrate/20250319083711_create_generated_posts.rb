class CreateGeneratedPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :generated_posts do |t|
      t.text :content
      t.boolean :posted
      t.datetime :posted_at

      t.timestamps
    end
  end
end
