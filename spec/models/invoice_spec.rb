require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe 'validations' do
    it { should validate_presence_of :customer_id }
    it { should validate_presence_of :status }
  end

  describe '#applicable_discount' do
    it "shows only the highest percentage applicable discount and returns several calculations" do
      customer_1 = Customer.create(first_name: "Joey", last_name:"One")

      merchant_1 = Merchant.create(name: "merchant1")
      merchant_2 = Merchant.create(name: "merchant2")
      merchant_3 = Merchant.create(name: "merchant3")
      merchant_4 = Merchant.create(name: "merchant")
      merchant_5 = Merchant.create(name: "merchant")
      merchant_6 = Merchant.create(name: "merchant")
      merchant_7 = Merchant.create(name: "merchant")

      discount_1 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_1)
      discount_2 = BulkDiscount.create(percentage: 10, quantity: 5, merchant: merchant_1)
      discount_3 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_2)
      discount_4 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_3)
      discount_5 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_4)
      discount_6 = BulkDiscount.create(percentage: 30, quantity: 15, merchant: merchant_4)
      discount_7 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_5)
      discount_8 = BulkDiscount.create(percentage: 15, quantity: 15, merchant: merchant_5)
      discount_9 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_6)
      discount_10 = BulkDiscount.create(percentage: 30, quantity: 15, merchant: merchant_6)

      item_1 = Item.create(name: "item1", description: "1", unit_price: 2145, merchant: merchant_1)
      item_2 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_1)
      item_3 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_2)
      item_4 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_2)
      item_5 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_3)
      item_6 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_3)
      item_7 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_4)
      item_8 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_4)
      item_9 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_5)
      item_10 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_5)
      item_11 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_6)
      item_12 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_6)
      item_13 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_7)

      invoice_1 = Invoice.create(customer: customer_1, status: 0)
      invoice_2 = Invoice.create(customer: customer_1, status: 0)
      invoice_3 = Invoice.create(customer: customer_1, status: 0)
      invoice_4 = Invoice.create(customer: customer_1, status: 0)
      invoice_5 = Invoice.create(customer: customer_1, status: 0)
      invoice_6 = Invoice.create(customer: customer_1, status: 0)
      
      invoice_item_1 = InvoiceItem.create(item: item_1, invoice: invoice_1, quantity: 5, unit_price: 100, status: 0)
      invoice_item_2 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 10, unit_price: 1000, status: 1)
      invoice_item_3 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 2, unit_price: 100, status: 1)

      invoice_item_4 = InvoiceItem.create(item: item_3, invoice: invoice_2, quantity: 5, unit_price: 34343, status: 0)
      invoice_item_5 = InvoiceItem.create(item: item_4, invoice: invoice_2, quantity: 5, unit_price: 34343, status: 1)

      invoice_item_6 = InvoiceItem.create(item: item_5, invoice: invoice_3, quantity: 10, unit_price: 10, status: 1)
      invoice_item_7 = InvoiceItem.create(item: item_6, invoice: invoice_3, quantity: 5, unit_price: 10, status: 1)

      invoice_item_5 = InvoiceItem.create!(item: item_7, invoice: invoice_4, quantity: 12, unit_price: 100, status: 1)
      invoice_item_6 = InvoiceItem.create(item: item_8, invoice: invoice_4, quantity: 15, unit_price: 10, status: 1)

      invoice_item_7 = InvoiceItem.create(item: item_9, invoice: invoice_5, quantity: 12, unit_price: 100, status: 1)
      invoice_item_8 = InvoiceItem.create(item: item_10, invoice: invoice_5, quantity: 15, unit_price: 100, status: 1)

      invoice_item_9 = InvoiceItem.create(item: item_11, invoice: invoice_6, quantity: 12, unit_price: 100, status: 1)
      invoice_item_10 = InvoiceItem.create(item: item_12, invoice: invoice_6, quantity: 15, unit_price: 100, status: 1)
      invoice_item_11 = InvoiceItem.create(item: item_13, invoice: invoice_6, quantity: 15, unit_price: 100, status: 1)
      
      expect(invoice_1.applicable_discount).to eq(2050)
      expect(invoice_2.applicable_discount).to eq(0)
      expect(invoice_3.applicable_discount).to eq(20)
      expect(invoice_4.applicable_discount).to eq(285)
      expect(invoice_5.applicable_discount).to eq(540)
      expect(invoice_6.applicable_discount).to eq(690)

      # expect(invoice_1.calculated_discount[0].discount_total_off).to eq(50)
      # expect(invoice_2.calculated_discount[0].discount_total_off).to eq(0)
      # expect(invoice_3.calculated_discount[0].discount_total_off).to eq(20)
      # expect(invoice_4.calculated_discount[0].discount_total_off).to eq(285)
      # expect(invoice_5.calculated_discount[0].discount_total_off).to eq(540)
      # expect(invoice_6.calculated_discount[0].discount_total_off).to eq(690)
    end
  end

  describe '#possible_discounts' do
  it "shows only the highest percentage applicable discount and returns several calculations" do
    customer_1 = Customer.create(first_name: "Joey", last_name:"One")

    merchant_1 = Merchant.create(name: "merchant1")

    discount_1 = BulkDiscount.create(percentage: 20, quantity: 10, merchant: merchant_1)
    discount_2 = BulkDiscount.create(percentage: 10, quantity: 5, merchant: merchant_1)

    item_1 = Item.create(name: "item1", description: "1", unit_price: 2145, merchant: merchant_1)
    item_2 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_1)

    invoice_1 = Invoice.create(customer: customer_1, status: 0)
    
    invoice_item_1 = InvoiceItem.create(item: item_1, invoice: invoice_1, quantity: 5, unit_price: 100, status: 0)
    invoice_item_2 = InvoiceItem.create(item: item_2, invoice: invoice_1, quantity: 10, unit_price: 1000, status: 1)
    invoice_item_3 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 2, unit_price: 100, status: 1)
    
    expect(invoice_1.possible_discounts[0].percentage).to eq(10)
    expect(invoice_1.possible_discounts[1].percentage).to eq(20)
    expect(invoice_1.possible_discounts[0].discount_total_off).to eq(50)
    expect(invoice_1.possible_discounts[1].discount_total_off).to eq(2000)
  end
end

  context 'standard set up' do
    before :each do
      @customer_1 = Customer.create(first_name: "Joey", last_name:"One")

      @merchant_1 = Merchant.create(name: "merchant1")
      @item_1 = Item.create(name: "item1", description: "1", unit_price: 2145, merchant: @merchant_1)
      @item_2 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: @merchant_1)

      @invoice_1 = Invoice.create(customer: @customer_1, status: 0)
      @invoice_2 = Invoice.create(customer: @customer_1, status: 1)
      @invoice_3 = Invoice.create(customer: @customer_1, status: 2)

      @invoice_item_1 = InvoiceItem.create(item: @item_1, invoice: @invoice_1, quantity: 23, unit_price: 34343, status: 0)
      @invoice_item_2 = InvoiceItem.create(item: @item_1, invoice: @invoice_1, quantity: 23, unit_price: 34343, status: 1)
      @invoice_item_3 = InvoiceItem.create(item: @item_1, invoice: @invoice_2, quantity: 23, unit_price: 34343, status: 2)
      @invoice_item_4 = InvoiceItem.create(item: @item_1, invoice: @invoice_2, quantity: 23, unit_price: 34343, status: 0)
      @invoice_item_5 = InvoiceItem.create(item: @item_1, invoice: @invoice_3, quantity: 23, unit_price: 34343, status: 2)
      @invoice_item_6 = InvoiceItem.create(item: @item_2, invoice: @invoice_3, quantity: 23, unit_price: 34343, status: 2)
    end

    describe 'class methods' do
      describe '#incomplete_invoices' do
        it "shows a list of invoices that have not yet shipped" do
          expect(Invoice.incomplete_invoices).to eq([@invoice_1, @invoice_2])
        end
      end
    end
  end

  describe '#total_revenue' do
    it "shows a list of invoices that have not yet shipped and orders by oldest invoice by created_at" do
      customer_1 = Customer.create(first_name: "Joey", last_name:"One")
      merchant_1 = Merchant.create(name: "merchant1")
      item_1 = Item.create(name: "item1", description: "1", unit_price: 2145, merchant: merchant_1)
      item_2 = Item.create(name: "item2", description: "1", unit_price: 2145, merchant: merchant_1)
      invoice_1 = Invoice.create(customer: customer_1, status: 0)
  
      invoice_item_1 = InvoiceItem.create(item: item_1, invoice: invoice_1, quantity: 1, unit_price: 34343, status: 0)
      invoice_item_2 = InvoiceItem.create(item: item_1, invoice: invoice_1, quantity: 2, unit_price: 34343, status: 1)
      expect(invoice_1.total_revenue).to eq(1030.29)
    end
  end
end