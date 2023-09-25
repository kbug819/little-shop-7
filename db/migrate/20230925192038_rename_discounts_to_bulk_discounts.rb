class RenameDiscountsToBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    rename_table :discounts, :bulk_discount
  end
end
