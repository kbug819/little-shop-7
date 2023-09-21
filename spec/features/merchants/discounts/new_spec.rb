require "rails_helper"

RSpec.feature "the merchant discounts index page" do
  describe 'when visiting /merchants/merchant_id/invoices' do
    it 'US1 - solo project - displays a list of merchant discounts' do
      merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
      discount_1 = Discount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = Discount.create!(percentage: 30, quantity: 15, merchant: merchant_1)

      visit merchant_discounts_path(merchant_1.id)
      
      expect(page).to have_button("Add a New Discount")
      click_button("Add a New Discount")
      expect(page).to have_current_path("/merchants/#{merchant_1.id}/discounts/new")
      expect(page).to have_content("Create A New Discount for #{merchant_1.name}")
      expect(page).to have_content("Percentage")
      expect(page).to have_content("Quantity")
      fill_in("Percentage", with: "25")
      fill_in("Quantity", with: "10")
      click_button("Submit")
      expect(page).to have_current_path("/merchants/#{merchant_1.id}/discounts")
      expect(page).to have_content("#{discount_1.percentage}% off #{discount_1.quantity} items")
      expect(page).to have_content("#{discount_2.percentage}% off #{discount_2.quantity} items")
      expect(page).to have_content("25% off 10 items")
    end
  end
end