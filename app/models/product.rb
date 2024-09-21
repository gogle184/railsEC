class Product < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :small, resize_to_limit: [200, 200]
    attachable.variant :large, resize_to_limit: [500, 500]
  end

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, less_than: 1_000_000 }
  validates :description, presence: true, length: { maximum: 10000 }

  scope :order_by_position, -> { order(:position) }
  scope :displayed, -> { where(display: true) }

  acts_as_list

  def add_tax_price
    (self.price * 1.10).floor
  end
end
