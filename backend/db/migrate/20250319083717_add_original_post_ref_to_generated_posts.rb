class AddOriginalPostRefToGeneratedPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :generated_posts, :original_post, null: false, foreign_key: { to_table: :posts }
  end
end
