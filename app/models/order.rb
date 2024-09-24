class Order < ApplicationRecord
  include OrderWithItems
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :schedule_date, presence: true
  validate :schedule_date_in_business_range

  scope :order_by_newest, -> { order(id: :desc) }

  enum :status, { waiting: 0, shipped: 1, completed: 2, canceled: 3 }
  enum :schedule_time, { none: 0, eight_twelve: 1, twelve_fourteen: 2, fourteen_sixteen: 3, sixteen_eighteen: 4, eighteen_twenty: 5, twenty_twenty_one: 6 },
       prefix: :schedule

  before_update :handle_status_change

  def tax_included_total_price(no_tax_total_price)
    (no_tax_total_price * 1.10).floor
  end

  def cash_on_delivery_method(tax_in_total_price)
    case tax_in_total_price
    when 0...10_000
      330
    when 10_000...30_000
      440
    when 30_000...100_000
      660
    else
      1_100
    end
  end

  def shipping_fee_method(total_quantity)
    660 + ((total_quantity / 5).ceil * 660)
  end

  def final_total_price(tax_in_total_price, total_quantity)
    tax_in_total_price + cash_on_delivery_method(tax_in_total_price) + shipping_fee_method(total_quantity)
  end

  def self.min_schedule_date
    3.business_days.from_now.to_date
  end

  def self.max_schedule_date
    14.business_days.from_now.to_date
  end

  def total_price
    order_items.sum { |item| item.quantity * item.tax_in_price }
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def final_sub_total_price(order)
    total_price + order.cash_on_delivery + order.shipping_fee
  end

  private

  def schedule_date_in_business_range
    if schedule_date.present? && (schedule_date < 3.business_days.from_now.to_date || schedule_date > 14.business_days.from_now.to_date)
      errors.add(:schedule_date, :unrange)
    end
  end

  # TODO: ステータスごとの処理の追加
  def handle_status_change
    return unless status_changed?

    case status
    when 'shipped'
      UserMailer.order_shipped(self).deliver_later
    when 'completed'
      self.delivered_time = Time.current
    end
  end
end
