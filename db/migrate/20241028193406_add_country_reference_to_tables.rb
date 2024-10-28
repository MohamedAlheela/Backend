class AddCountryReferenceToTables < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :country, foreign_key: true
    add_reference :orders, :country, foreign_key: true
    add_reference :products, :country, foreign_key: true
  end
end
