require "rails_helper"

RSpec.feature "the merchant discounts show page" do
  describe 'when visiting /merchants/merchant_id/invoices' do
    it 'US4 - solo project - displays a list of merchant discount details for specific id' do
      merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
      discount_1 = BulkDiscount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = BulkDiscount.create!(percentage: 30, quantity: 15, merchant: merchant_1)

      visit dashboard_merchants_path(merchant_1.id)
      
      expect(page).to have_button("View Discounts")
      click_button("View Discounts")
      expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts")
      within "tr#discount-#{discount_1.id}" do
        expect(page).to have_content("#{discount_1.percentage}% off #{discount_1.quantity} items")
        expect(page).to have_link("#{discount_1.percentage}% off #{discount_1.quantity} items")
      end
      within "tr#discount-#{discount_2.id}" do
        expect(page).to have_content("#{discount_2.percentage}% off #{discount_2.quantity} items")
        expect(page).to have_link("#{discount_2.percentage}% off #{discount_2.quantity} items")
        click_link("#{discount_2.percentage}% off #{discount_2.quantity} items")
      end
      expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts/#{discount_2.id}")
    end
  end  
  describe 'when visiting /merchants/merchant_id/invoices' do
    it 'US5 - solo project - shows button to update the entry for discount' do
      merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
      discount_1 = BulkDiscount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = BulkDiscount.create!(percentage: 30, quantity: 15, merchant: merchant_1)

      visit "/merchants/#{merchant_1.id}/bulk_discounts/#{discount_2.id}"
      
      expect(page).to have_content("#{discount_2.percentage}% off #{discount_2.quantity}")
      expect(page).to have_button("Edit Discount")
      click_button("Edit Discount")
      expect(page).to have_current_path(edit_merchant_bulk_discount_path(merchant_1, discount_2))
      expect(page).to have_content("#{discount_2.percentage}% off #{discount_2.quantity}")
      expect(page).to have_content("Percentage")
      expect(page).to have_content("Quantity")
      fill_in("Percentage", with: "25")
      fill_in("Quantity", with: "10")
      click_button("Submit")
      expect(page).to have_current_path(merchant_bulk_discount_path(merchant_1, discount_2))
      expect(page).to have_content("25% off 10")
    end
  end

  
end