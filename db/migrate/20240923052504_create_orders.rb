class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status,null: false, default: 0
      t.date :schedule_date
      t.integer :schedule_time
      t.datetime :delivered_time
      
      t.timestamps
    end
  end
end
