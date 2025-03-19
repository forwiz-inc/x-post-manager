class GeneratedPost < ApplicationRecord
  belongs_to :original_post, class_name: 'Post'

  validates :content, presence: true
end
