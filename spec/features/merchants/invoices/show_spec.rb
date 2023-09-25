require "rails_helper"

RSpec.feature "the merchant invoices show page" do
  describe 'when visiting /merchants/merchant_id/invoices/:invoice_id' do
    it 'US15 displays the merchants invoice with details' do
      merchant = Merchant.create!(name: "Bracelets 'n Stuff")
      item = merchant.items.create!(name: "Bracelet", description: "Shiny", unit_price: 100)
      customer = Customer.create!(first_name: "Robert", last_name: "Redford")
      invoice = customer.invoices.create!(status: 0)
      invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: 100, status: 0)

      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

      expect(page).to have_content("ID: #{invoice.id}")
      expect(page).to have_content("Status: #{invoice.status}")
      expect(page).to have_content("Created At: #{invoice.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("Customer Name: #{customer.first_name} #{customer.last_name}")
    end

    it 'US16 and 17 displays the item details of the invoice' do
      merchant = create(:merchant)
      items = create_list(:item, 3, merchant: merchant)
      invoice = create(:invoice)
      invoice_items_0 = create(:invoice_item, item: items[0], invoice: invoice)
      invoice_items_1 = create(:invoice_item, item: items[1], invoice: invoice)
      invoice_items_2 = create(:invoice_item, item: items[2], invoice: invoice)

      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

      within "#invoice-item-#{invoice_items_0.id}" do
        expect(page).to have_content(items[0].name)
        expect(page).to have_content(invoice_items_0.quantity)
        expect(page).to have_content(invoice_items_0.unit_price / 100.00)
      end

      within "#invoice-item-#{invoice_items_1.id}" do
        expect(page).to have_content(items[1].name)
        expect(page).to have_content(invoice_items_1.quantity)
        expect(page).to have_content(invoice_items_1.unit_price / 100.00)
      end

      within "#invoice-item-#{invoice_items_2.id}" do
        expect(page).to have_content(items[2].name)
        expect(page).to have_content(invoice_items_2.quantity)
        expect(page).to have_content(invoice_items_2.unit_price / 100.00)
      end
      
      expect(page).to have_content("Total Revenue of Invoice: $#{invoice.total_revenue}")
    end

    it "US18 changing the status of an invoice" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice)
      invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, status: 0)

      visit merchant_invoice_path(merchant_1, invoice_1)

      expect(invoice_item_1.status).to eq("packaged")
      expect(page).to have_select(:item_status, options: ['packaged', 'pending', 'shipped'])
      select('pending', from: :item_status)
      click_button('Update Item Status')
      invoice_item_1.reload
      
      expect(current_path).to eq(merchant_invoice_path(merchant_1, invoice_1))
      expect(invoice_item_1.status).to eq('pending')
    end
  end

  describe 'when visiting /merchants/merchant_id/invoices' do
    it 'US6 - solo project - shows total revenue and revenue after bulk discounts applied' do
      customer_1 = Customer.create(first_name: "Joey", last_name:"One")

      merchant_1 = Merchant.create(name: "merchant1")
      merchant_2 = Merchant.create(name: "merchant2")

      discount_1 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = BulkDiscount.create(percentage: 10, quantity: 5, merchant: merchant_1)
      item_1 = Item.create(name: "item1", description: "1", unit_price: 2145, merchant: merchant_1)
      item_2 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_1)
      item_3 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_2)
      invoice_1 = Invoice.create(customer: customer_1, status: 0)
      
      invoice_item_1 = InvoiceItem.create(item: item_1, invoice: invoice_1, quantity: 5, unit_price: 500, status: 0)
      invoice_item_2 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 10, unit_price: 500, status: 1)
      invoice_item_3 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 1, unit_price: 1000, status: 1)
      invoice_item_3 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 1, unit_price: 1000, status: 1)

      visit merchant_invoice_path(merchant_1, invoice_1)
      
      expect(page).to have_content("Total Revenue of Invoice: $95.00")
      expect(page).to have_content("Total Discounted Revenue: $82.50")
    end
  end
end