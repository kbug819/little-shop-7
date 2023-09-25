require "rails_helper"

RSpec.feature "the merchant discount new page" do
  describe 'when visiting /merchants/merchant_id/discounts/new' do
    it 'US2 - solo project - creates form to add a discount' do
      merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
      discount_1 = BulkDiscount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = BulkDiscount.create!(percentage: 30, quantity: 15, merchant: merchant_1)

      visit merchant_bulk_discounts_path(merchant_1.id)
      
      expect(page).to have_button("Add a New Discount")
      click_button("Add a New Discount")
      expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts/new")
      expect(page).to have_content("Create A New Discount for #{merchant_1.name}")
      expect(page).to have_content("Percentage")
      expect(page).to have_content("Quantity")
      click_button("Submit")
      expect(page).to have_content("Item not created: Required information missing.")
      fill_in("Percentage", with: "25")
      click_button("Submit")
      expect(page).to have_content("Item not created: Required information missing.")
      fill_in("Quantity", with: "10")
      click_button("Submit")
      expect(page).to have_content("Item not created: Required information missing.")
      fill_in("Percentage", with: "25")
      fill_in("Quantity", with: "10")
      click_button("Submit")

      expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts")
      within "tr#discount-#{discount_1.id}" do
        expect(page).to have_content("#{discount_1.percentage}% off #{discount_1.quantity} items")
      end
      within "tr#discount-#{discount_2.id}" do
        expect(page).to have_content("#{discount_2.percentage}% off #{discount_2.quantity} items")
      end
      expect(page).to have_content("25% off 10 items")
    end
  end
end