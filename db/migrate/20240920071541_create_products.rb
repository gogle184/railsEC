class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description, null: false
      t.boolean :display, null: false, default: false

      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
