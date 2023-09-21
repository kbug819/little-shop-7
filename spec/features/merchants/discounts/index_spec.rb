require "rails_helper"

RSpec.feature "the merchant discounts index page" do
  describe 'when visiting /merchants/merchant_id/invoices' do
    xit 'US14 displays a list of merchant invoice with a button to each invoice show page' do
      merchant = Merchant.create!(name: "Bracelets 'n Stuff")
      item = merchant.items.create!(name: "Bracelet", description: "Shiny", unit_price: 100)
      customer = Customer.create!(first_name: "Robert", last_name: "Redford")
      invoice = customer.invoices.create!(status: 0)
      invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: 100, status: 0)

      visit dashboard_merchants_path
      
      expect(page).to have_link("My Discounts")
      click_link("discounts")
      expect(page).to have_current_path("/merchants/#{merchant.id}/discounts")
      within ".bulk_discounts" do
        expect(page).to have_content("/merchants/#{merchant.id}/discounts")
      end
    end
  end
end
