class AddNameToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_orders, :billing_lastname, :string
    add_column :spree_orders, :billing_firstname, :string
  end
end
