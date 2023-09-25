require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'validations' do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
  end

  describe '#unit_price_to_decimal' do
    it "formats the unit price of an invoice item" do
      customer_1 = Customer.create(first_name: "Joey", last_name:"One")
      merchant_1 = Merchant.create(name: "merchant1")
      item_1 = Item.create(name: "item1", description: "1", unit_price: 2145, merchant: merchant_1)
      item_2 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_1)

      invoice_1 = Invoice.create(customer: customer_1, status: 0)

      invoice_item_1 = InvoiceItem.create(item: item_1, invoice: invoice_1, quantity: 23, unit_price: 34343, status: 0)
      invoice_item_2 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 23, unit_price: 34343, status: 1)

      expect(invoice_item_1.unit_price_to_decimal).to eq(343.43)
    end
  end
  
  describe '#available_discounts' do
    it "shows only the highest percentage applicable discount and returns several calculations" do
      customer_1 = Customer.create(first_name: "Joey", last_name:"One")

      merchant_1 = Merchant.create(name: "merchant1")
      merchant_2 = Merchant.create(name: "merchant2")

      discount_1 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = BulkDiscount.create(percentage: 30, quantity: 15, merchant: merchant_1)
      discount_3 = BulkDiscount.create(percentage: 15, quantity: 15, merchant: merchant_1)
      item_1 = Item.create(name: "item1", description: "1", unit_price: 2145, merchant: merchant_1)
      item_2 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_1)
      item_3 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_2)
      invoice_1 = Invoice.create(customer: customer_1, status: 0)
      
      invoice_item_1 = InvoiceItem.create(item: item_1, invoice: invoice_1, quantity: 5, unit_price: 34343, status: 0)
      invoice_item_2 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 5, unit_price: 34343, status: 1)
      invoice_item_3 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 10, unit_price: 1000, status: 1)
      invoice_item_4 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 5, unit_price: 34343, status: 1)
      invoice_item_5 = InvoiceItem.create!(item: item_2, invoice: invoice_1, quantity: 12, unit_price: 100, status: 1)
      invoice_item_6 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 15, unit_price: 34343, status: 1)
      invoice_item_7 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 12, unit_price: 34343, status: 1)
      invoice_item_8 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 15, unit_price: 34343, status: 1)
      invoice_item_9 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 12, unit_price: 34343, status: 1)
      invoice_item_10 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 15, unit_price: 34343, status: 1)
      invoice_item_11 = InvoiceItem.create(item: item_3, invoice: invoice_1, quantity: 15, unit_price: 34343, status: 1)
      

      expect(invoice_item_1.available_discounts).to eq([])
      expect(invoice_item_2.available_discounts).to eq([])
      expect(invoice_item_3.available_discounts).to eq([discount_1])
      expect(invoice_item_3.available_discounts[0].total_price).to eq(10000)
      expect(invoice_item_3.available_discounts[0].discount_total_off).to eq(2000)
      expect(invoice_item_3.available_discounts[0].discounted_total).to eq(8000)

      expect(invoice_item_4.available_discounts).to eq([])

      expect(invoice_item_5.available_discounts).to eq([discount_1])
      expect(invoice_item_5.available_discounts[0].total_price).to eq(1200)
      expect(invoice_item_5.available_discounts[0].discount_total_off).to eq(240)
      expect(invoice_item_5.available_discounts[0].discounted_total).to eq(960)
      expect(invoice_item_6.available_discounts).to eq([discount_2])
      expect(invoice_item_7.available_discounts).to eq([discount_1])
      expect(invoice_item_8.available_discounts).to eq([discount_2])
      expect(invoice_item_9.available_discounts).to eq([discount_1])
      expect(invoice_item_10.available_discounts).to eq([discount_2])
      expect(invoice_item_11.available_discounts).to eq([])
    end
  end
end