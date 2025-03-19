class Keyword < ApplicationRecord
  has_many :post_keywords, dependent: :destroy
  has_many :posts, through: :post_keywords

  validates :word, presence: true, uniqueness: true
  
  # デフォルト値の設定
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.active = true if self.active.nil?
  end
end
