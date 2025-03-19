class PostKeyword < ApplicationRecord
  belongs_to :post
  belongs_to :keyword

  validates :post_id, uniqueness: { scope: :keyword_id }
end
