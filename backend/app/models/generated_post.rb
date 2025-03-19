class GeneratedPost < ApplicationRecord
  belongs_to :original_post, class_name: 'Post'

  validates :content, presence: true
  
  # デフォルト値の設定
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.posted = false if self.posted.nil?
  end
end
