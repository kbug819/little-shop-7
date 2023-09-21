require "rails_helper"

RSpec.feature "the merchant discounts index page" do
  describe 'when visiting /merchants/merchant_id/invoices' do
    it 'US14 displays a list of merchant invoice with a button to each invoice show page' do
      merchant_1 = Merchant.create!(name: "Bracelets 'n Stuff")
      discount_1 = Discount.create!(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = Discount.create!(percentage: 30, quantity: 15, merchant: merchant_1)
      item = merchant_1.items.create!(name: "Bracelet", description: "Shiny", unit_price: 100)
      customer = Customer.create!(first_name: "Robert", last_name: "Redford")
      invoice = customer.invoices.create!(status: 0)
      invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: 100, status: 0)

      visit dashboard_merchants_path(merchant_1.id)
      
      expect(page).to have_button("View Discounts")
      click_button("View Discounts")
      expect(page).to have_current_path("/merchants/#{merchant_1.id}/discounts")
      within ".bulk_discounts" do
        expect(page).to have_content("#{discount_1.percentage}% off #{discount_1.quantity} items")
        expect(page).to have_content("#{discount_2.percentage}% off #{discount_2.quantity} items")
        expect(page).to have_link("#{discount_1.percentage}% off #{discount_1.quantity} items")
        expect(page).to have_link("#{discount_2.percentage}% off #{discount_2.quantity} items")
        click_link("#{discount_2.percentage}% off #{discount_2.quantity} items")
        expect(page).to have_current_path("/merchants/#{merchant_1.id}/discounts/#{discount_2.id}")

      end
    end
  end
end
