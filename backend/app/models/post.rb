class Post < ApplicationRecord
  has_many :post_keywords, dependent: :destroy
  has_many :keywords, through: :post_keywords
  has_many :generated_posts, foreign_key: 'original_post_id', dependent: :destroy

  validates :x_post_id, presence: true, uniqueness: true
  validates :content, presence: true
  validates :author_username, presence: true
  validates :posted_at, presence: true
end
