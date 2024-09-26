class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :diary

  validates :content, presence: true, length: { maximum: 140 }

  scope :order_by_newest, -> { order(created_at: :desc) }
end
