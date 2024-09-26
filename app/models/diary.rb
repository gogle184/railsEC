class Diary < ApplicationRecord
  has_one_attached :diary_image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  scope :order_by_newest, -> { order(created_at: :desc) }
  scope :displayed, -> { where(display: true) }
end
