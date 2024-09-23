class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.date :schedule_date, null: false
      t.integer :schedule_time, null: false, default: 0
      t.integer :shipping_fee, null: false
      t.integer :cash_on_delivery, null: false
      t.datetime :delivered_time

      t.timestamps
    end
  end
end
