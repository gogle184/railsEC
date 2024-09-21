class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :display_name, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :phone_number, presence: true, numericality: { only_integer: true }
  validates :postal_code, presence: true, numericality: { only_integer: true }, length: { maximum: 7 }
  validates :address, presence: true, length: { maximum: 128 }

  scope :order_by_oldest, -> { order(:id) }
end
