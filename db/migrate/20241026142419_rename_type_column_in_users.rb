class RenameTypeColumnInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :type, :role
  end
end
