class AddColumnPositionToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :position, :integer, null: false # rubocop:disable Rails/NotNullColumn
  end
end
