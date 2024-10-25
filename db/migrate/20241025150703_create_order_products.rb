class CreateOrderProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :order_products do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.boolean :include_iron, default: false, null: false

      t.timestamps
    end

    add_index :order_products, [:order_id, :product_id], unique: true
  end
end
