class Post < ApplicationRecord
  has_many :post_keywords, dependent: :destroy
  has_many :keywords, through: :post_keywords
  has_many :generated_posts, foreign_key: 'original_post_id', dependent: :destroy

  validates :x_post_id, presence: true, uniqueness: true
  validates :content, presence: true
  validates :author_username, presence: true
  validates :posted_at, presence: true
  
  # デフォルト値の設定
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.used = false if self.used.nil?
    self.likes_count ||= 0
  end
end
