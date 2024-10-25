class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.float :latitude
      t.float :longitude
      t.string :address
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.references :deliverer, null: false, foreign_key: { to_table: :users }
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.datetime :delivery_time

      t.timestamps
    end
    
    add_index :orders, [:deliverer_id, :customer_id]
  end
end
