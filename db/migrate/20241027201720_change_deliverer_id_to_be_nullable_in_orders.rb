class ChangeDelivererIdToBeNullableInOrders < ActiveRecord::Migration[7.1]
  def change
    change_column_null :orders, :deliverer_id, true
  end
end
