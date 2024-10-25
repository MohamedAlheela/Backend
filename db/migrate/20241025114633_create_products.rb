class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :iron_price, precision: 10, scale: 2, null: false
      t.integer :discount, default: 0, null: false

      t.timestamps
    end
  end
end
