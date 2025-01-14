class AddSpreeBankTransfersInstructionUrl < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_bank_transfers, :instructions_url, :string
  end
end
