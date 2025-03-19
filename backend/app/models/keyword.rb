class Keyword < ApplicationRecord
  has_many :post_keywords, dependent: :destroy
  has_many :posts, through: :post_keywords

  validates :word, presence: true, uniqueness: true
end
