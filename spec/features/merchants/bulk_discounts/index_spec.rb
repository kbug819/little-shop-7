require "rails_helper"

RSpec.feature "the merchant discounts index page" do
  describe 'when visiting /merchants/merchant_id/invoices' do
    it 'US1 - solo project - displays a list of merchant discounts' do
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

    describe 'when visiting Merchant Discount index' do
      it 'US2 - Solo Project displays a list of merchant discounts, adds a button to add a discount' do
        merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
        discount_1 = BulkDiscount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
        discount_2 = BulkDiscount.create!(percentage: 30, quantity: 15, merchant: merchant_1)
  
        visit dashboard_merchants_path(merchant_1.id)
        
        expect(page).to have_button("View Discounts")
        click_button("View Discounts")
        expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts")
        expect(page).to have_button("Add a New Discount")
        click_button("Add a New Discount")
        expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts/new")
      end
    end

    describe 'when visiting Merchant Discount index' do
      it 'US3 - Solo Project displays a delete button next to each discount' do
        merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
        discount_1 = BulkDiscount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
        discount_2 = BulkDiscount.create!(percentage: 30, quantity: 15, merchant: merchant_1)
  
        visit merchant_bulk_discounts_path(merchant_1.id)
        within "tr#discount-#{discount_1.id}" do
          expect(page).to have_content("#{discount_1.percentage}% off #{discount_1.quantity} items")
          expect(page).to have_link("#{discount_1.percentage}% off #{discount_1.quantity} items")
          expect(page).to have_button("Delete Discount")
        end
        within "tr#discount-#{discount_2.id}" do
          expect(page).to have_content("#{discount_2.percentage}% off #{discount_2.quantity} items")
          expect(page).to have_link("#{discount_2.percentage}% off #{discount_2.quantity} items")
          expect(page).to have_button("Delete Discount")
          click_button("Delete Discount")
        end
          expect(page).to_not have_content("#{discount_2.percentage}% off #{discount_2.quantity} items")
          expect(page).to have_content("#{discount_1.percentage}% off #{discount_1.quantity} items")
      end
    end

    describe 'when visiting Merchant Discount index' do
      it 'API Extention - Solo Project create discount button next to each of the 3 upcoming holidays.' do
        merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
        discount_1 = BulkDiscount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
        discount_2 = BulkDiscount.create!(percentage: 30, quantity: 15, merchant: merchant_1)
  
        visit merchant_bulk_discounts_path(merchant_1.id)
        within "tr#holiday_discount-2023-10-09" do
          expect(page).to have_content("2023-10-09 - Columbus Day")
          expect(page).to have_button("Add a New Holiday Discount")
        end
        within "tr#holiday_discount-2023-11-10" do
          expect(page).to have_content("2023-11-10 - Veterans Day")
          expect(page).to have_button("Add a New Holiday Discount")
        end
        within "tr#holiday_discount-2023-11-23" do
          expect(page).to have_content("2023-11-23 - Thanksgiving Day")
          expect(page).to have_button("Add a New Holiday Discount")
          click_button("Add a New Holiday Discount")
        end
        expect(page).to have_content("Create A New Holiday Discount for #{merchant_1.name}")
        click_button("Submit")
        expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts")
        expect(page).to have_content("30% off 2 items")
      end
    end
  end
end
