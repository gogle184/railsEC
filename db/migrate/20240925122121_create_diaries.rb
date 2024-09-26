class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :display, null: false, default: true

      t.timestamps
    end

    add_index :diaries, %i[title user_id], unique: true
  end
end
