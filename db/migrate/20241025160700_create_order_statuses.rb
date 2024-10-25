class CreateOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_statuses do |t|
      t.references :order, null: false, foreign_key: true
      t.datetime :time, null: false
      t.text :note
      t.integer :name, null: false, default: 0

      t.timestamps
    end
  end
end
