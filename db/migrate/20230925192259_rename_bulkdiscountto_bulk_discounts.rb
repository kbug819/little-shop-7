class RenameBulkdiscounttoBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    rename_table :bulk_discount, :bulk_discounts

  end
end
