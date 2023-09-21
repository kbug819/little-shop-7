require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :discounts }
  end

  describe "validations" do
    it { should validate_presence_of :name}
  end

  describe "instance methods" do 
    describe '#top_five_items' do
      it "US3 queries the top customers" do 
        merchant_1 = Merchant.create(name: "Merchant 1")

        item_1 = Item.create(name: "Item 1", description: "Item 1 description", unit_price: 100, merchant_id: merchant_1.id)

        customer_1 = Customer.create(first_name: "Erica", last_name:"One")
        customer_2 = Customer.create(first_name: "Noelle", last_name:"Two")
        customer_3 = Customer.create(first_name: "Cory", last_name:"Three")
        customer_4 = Customer.create(first_name: "Terry", last_name:"Four")
        customer_5 = Customer.create(first_name: "Dani", last_name:"Five")
        customer_6 = Customer.create(first_name: "Juliet", last_name:"Six")

        invoice_1 = Invoice.create(customer_id: customer_1.id, status: 1)
        invoice_2 = Invoice.create(customer_id: customer_2.id, status: 1)
        invoice_3 = Invoice.create(customer_id: customer_3.id, status: 1)
        invoice_4 = Invoice.create(customer_id: customer_4.id, status: 1)
        invoice_5 = Invoice.create(customer_id: customer_5.id, status: 1)
        invoice_6 = Invoice.create(customer_id: customer_6.id, status: 1)

        invoice_items_1 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 100, status: 1)
        invoice_items_2 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 200, status: 1)
        invoice_items_3 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_3.id, quantity: 3, unit_price: 300, status: 1)
        invoice_items_4 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_4.id, quantity: 3, unit_price: 300, status: 1)
        invoice_items_5 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 300, status: 1)
        invoice_items_6 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_6.id, quantity: 3, unit_price: 300, status: 1)

        transaction_1 = Transaction.create(invoice_id: invoice_1.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_2 = Transaction.create(invoice_id: invoice_2.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_3 = Transaction.create(invoice_id: invoice_2.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_4 = Transaction.create(invoice_id: invoice_3.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_5 = Transaction.create(invoice_id: invoice_3.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_6 = Transaction.create(invoice_id: invoice_3.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_7 = Transaction.create(invoice_id: invoice_4.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_8 = Transaction.create(invoice_id: invoice_4.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_9 = Transaction.create(invoice_id: invoice_4.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_10 = Transaction.create(invoice_id: invoice_4.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_11 = Transaction.create(invoice_id: invoice_5.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_12 = Transaction.create(invoice_id: invoice_5.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_13 = Transaction.create(invoice_id: invoice_5.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_14 = Transaction.create(invoice_id: invoice_5.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_15 = Transaction.create(invoice_id: invoice_5.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_16 = Transaction.create(invoice_id: invoice_6.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_17 = Transaction.create(invoice_id: invoice_6.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_18 = Transaction.create(invoice_id: invoice_6.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_19 = Transaction.create(invoice_id: invoice_6.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_20 = Transaction.create(invoice_id: invoice_6.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        transaction_21 = Transaction.create(invoice_id: invoice_6.id, credit_card_number: 123456789, credit_card_expiration_date: 1234, result: 1)
        # require 'pry';binding.pry
        expect(merchant_1.top_five_customers).to eq([customer_6, customer_5, customer_4, customer_3, customer_2])
        expect(merchant_1.top_five_customers[0]).to eq(customer_6)
        expect(merchant_1.top_five_customers[0].transaction_count).to eq(6)
        expect(merchant_1.top_five_customers[1]).to eq(customer_5)
        expect(merchant_1.top_five_customers[1].transaction_count).to eq(5)
        expect(merchant_1.top_five_customers[2]).to eq(customer_4)
        expect(merchant_1.top_five_customers[2].transaction_count).to eq(4)
        expect(merchant_1.top_five_customers[3]).to eq(customer_3)
        expect(merchant_1.top_five_customers[3].transaction_count).to eq(3)
        expect(merchant_1.top_five_customers[4]).to eq(customer_2)
        expect(merchant_1.top_five_customers[4].transaction_count).to eq(2)
      end
    end


    before(:each) do
      @merchant_1 = Merchant.create!(name: "Queen Soopers", enabled: true)
      @merchant_2 = Merchant.create!(name: "Quick-E-Mart", enabled: true)
      @merchant_3 = Merchant.create!(name: "Veggi World", enabled: true)
      @merchant_4 = Merchant.create!(name: "Spatula City", enabled: true)
      @merchant_5 = Merchant.create!(name: "Just Powder", enabled: false)
      @merchant_6 = Merchant.create!(name: "Icee Freeze", enabled: false)
      @merchant_7 = Merchant.create!(name: "Water World", enabled: false)
    end
    
    describe '#popular_items' do
      before(:each) do
        @merchant = create(:merchant)
        @items = create_list(:item, 6, merchant: @merchant)
        @invoices = create_list(:invoice, 3)
        
        @invoice_items_data = [
          { item: @items[0], invoice: @invoices[0], quantity: 4, unit_price: 100 },
          { item: @items[1], invoice: @invoices[0], quantity: 1, unit_price: 200 },
          { item: @items[2], invoice: @invoices[1], quantity: 8, unit_price: 150 },
          { item: @items[3], invoice: @invoices[1], quantity: 6, unit_price: 100 },
          { item: @items[4], invoice: @invoices[2], quantity: 7, unit_price: 300 },
          { item: @items[5], invoice: @invoices[2], quantity: 1, unit_price: 500 }
        ]
        
        @invoice_items_data.each do |data|
          create(:invoice_item, data)
        end
        
        @invoices.each do |invoice|
          create(:transaction, invoice: invoice, result: 'success')
        end
      end
      
      it 'US 12 returns the top 5 items by total revenue' do
        expected_item_order = @invoice_items_data.group_by { |data| data[:item] }.map do |item, data|
          total_revenue = data.sum { |invoice_item| invoice_item[:quantity] * invoice_item[:unit_price] }
          [item, total_revenue]
        end.to_h.sort_by { |_, revenue| -revenue }.first(5).map(&:first)
        
        expect(@merchant.popular_items).to eq(expected_item_order)
      end

      describe '#items_ready_to_ship' do
        it "US 4 returns items ready to ship" do
          @merchant = Merchant.create!(name: "Queen Soopers", enabled: true)
          @item_1 = @merchant.items.create!(name: "Item 1", description: "Item 1 description", unit_price: 100, created_at: 1.day.ago, status: 0)
          @item_2 = @merchant.items.create!(name: "Item 2", description: "Item 2 description", unit_price: 200, created_at: 2.days.ago, status: 1)
          @item_3 = @merchant.items.create!(name: "Item 3", description: "Item 3 description", unit_price: 300, status: 0)
          @customer = Customer.create!(first_name: "Erica", last_name:"One")
          @invoice_1 = Invoice.create!(customer_id: @customer.id, status: 1 )
          @invoice_items_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 100, status: 0)
          @invoice_items_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 200, status: 1)
          @invoice_items_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 300, status: 2)

          expect(@merchant.items_ready_to_ship[0]).to eq(@item_1)
          expect(@merchant.items_ready_to_ship[1]).to eq(@item_2)
        end
      end
    end
  end

  before(:each) do
    @merchant_1 = Merchant.create!(name: "Queen Soopers", enabled: true)
    @merchant_2 = Merchant.create!(name: "Quick-E-Mart", enabled: true)
    @merchant_3 = Merchant.create!(name: "Veggi World", enabled: true)
    @merchant_4 = Merchant.create!(name: "Spatula City", enabled: true)
    @merchant_5 = Merchant.create!(name: "Just Powder", enabled: false)
    @merchant_6 = Merchant.create!(name: "Icee Freeze", enabled: false)
    @merchant_7 = Merchant.create!(name: "Water World", enabled: false)

    @merchant_1_items = create_list(:item, 10, merchant: @merchant_1)
    @merchant_2_items = create_list(:item, 10, merchant: @merchant_2)
    @merchant_3_items = create_list(:item, 10, merchant: @merchant_3)
    @merchant_4_items = create_list(:item, 10, merchant: @merchant_4)
    @merchant_5_items = create_list(:item, 10, merchant: @merchant_5)
    @merchant_6_items = create_list(:item, 10, merchant: @merchant_6)
    @merchant_7_items = create_list(:item, 10, merchant: @merchant_7)

    @customer1 = Customer.create!(first_name: "Bob", last_name: "Smith")
    @customer2 = Customer.create!(first_name: "Jane", last_name: "Smith")
    @customer3 = Customer.create!(first_name: "John", last_name: "Smith")
    @customer4 = Customer.create!(first_name: "Janet", last_name: "Smith")
    @customer5 = Customer.create!(first_name: "Johnathan", last_name: "Smith")
    @customer6 = Customer.create!(first_name: "Johnny", last_name: "Smith")
    @customer7 = Customer.create!(first_name: "Joseph", last_name: "Smith")
    @customer8 = Customer.create!(first_name: "Smelly", last_name: "Cow")

    @customer1_invoices = create_list(:invoice, 5, customer: @customer1, created_at: Time.new(2014,6,5))
    @customer2_invoices = create_list(:invoice, 5, customer: @customer2, created_at: Time.new(1998,4,7))
    @customer3_invoices = create_list(:invoice, 5, customer: @customer3, created_at: Time.new(1900,7,6))
    @customer4_invoices = create_list(:invoice, 5, customer: @customer4, created_at: Time.new(1997,7,6))
    @customer5_invoices = create_list(:invoice, 5, customer: @customer5, created_at: Time.new(1987,5,4))
    @customer6_invoices = create_list(:invoice, 5, customer: @customer6, created_at: Time.new(2001,6,5))
    @customer7_invoices = create_list(:invoice, 5, customer: @customer7, created_at: Time.new(2003,7,6))

    @invoice_item1 = InvoiceItem.create!(invoice: @customer1_invoices[0], item: @merchant_1_items[0], status: 0, unit_price: 423, quantity: 4)
    @invoice_item2 = InvoiceItem.create!(invoice: @customer1_invoices[2], item: @merchant_1_items[4], status: 0, unit_price: 5463, quantity: 6)
    @invoice_item3 = InvoiceItem.create!(invoice: @customer1_invoices[3], item: @merchant_1_items[5], status: 0, unit_price: 543, quantity: 9)
    @invoice_item4 = InvoiceItem.create!(invoice: @customer1_invoices[1], item: @merchant_1_items[6], status: 0, unit_price: 543, quantity: 3)
    @invoice_item5 = InvoiceItem.create!(invoice: @customer2_invoices[0], item: @merchant_1_items[6], status: 0, unit_price: 54, quantity: 8)
    @invoice_item6 = InvoiceItem.create!(invoice: @customer2_invoices[1], item: @merchant_2_items[0], status: 0, unit_price: 7465, quantity: 4)
    @invoice_item7 = InvoiceItem.create!(invoice: @customer2_invoices[4], item: @merchant_2_items[3], status: 0, unit_price: 45322, quantity: 3)
    @invoice_item8 = InvoiceItem.create!(invoice: @customer3_invoices[0], item: @merchant_3_items[0], status: 0, unit_price: 76556, quantity: 2)
    @invoice_item9 = InvoiceItem.create!(invoice: @customer3_invoices[2], item: @merchant_3_items[3], status: 0, unit_price: 6453, quantity: 1)
    @invoice_item10 = InvoiceItem.create!(invoice: @customer3_invoices[4], item: @merchant_4_items[7], status: 0, unit_price: 4532, quantity: 8)
    @invoice_item11 = InvoiceItem.create!(invoice: @customer4_invoices[0], item: @merchant_4_items[7], status: 0, unit_price: 9876, quantity: 4)
    @invoice_item12 = InvoiceItem.create!(invoice: @customer4_invoices[3], item: @merchant_4_items[9], status: 0, unit_price: 4533, quantity: 4)
    @invoice_item13 = InvoiceItem.create!(invoice: @customer5_invoices[0], item: @merchant_5_items[0], status: 0, unit_price: 768, quantity: 8)
    @invoice_item14 = InvoiceItem.create!(invoice: @customer5_invoices[1], item: @merchant_5_items[1], status: 0, unit_price: 8765, quantity: 3)
    @invoice_item15 = InvoiceItem.create!(invoice: @customer5_invoices[4], item: @merchant_5_items[7], status: 0, unit_price: 7645, quantity: 4)
    @invoice_item16 = InvoiceItem.create!(invoice: @customer6_invoices[0], item: @merchant_6_items[0], status: 0, unit_price: 4623, quantity: 4)
    @invoice_item17 = InvoiceItem.create!(invoice: @customer6_invoices[1], item: @merchant_6_items[7], status: 0, unit_price: 6876, quantity: 4)
    @invoice_item18 = InvoiceItem.create!(invoice: @customer7_invoices[0], item: @merchant_6_items[8], status: 0, unit_price: 4265, quantity: 4)
    @invoice_item19 = InvoiceItem.create!(invoice: @customer7_invoices[3], item: @merchant_6_items[3], status: 0, unit_price: 97568, quantity: 4)
    @invoice_item20 = InvoiceItem.create!(invoice: @customer7_invoices[2], item: @merchant_7_items[3], status: 0, unit_price: 3254, quantity: 4)

    create(:transaction, invoice: @customer1_invoices[0], result: "success")
    create(:transaction, invoice: @customer1_invoices[2], result: "failed")
    create(:transaction, invoice: @customer1_invoices[3], result: "success")
    create(:transaction, invoice: @customer1_invoices[1], result: "success")
    create(:transaction, invoice: @customer2_invoices[0], result: "failed")
    create(:transaction, invoice: @customer2_invoices[1], result: "success")
    create(:transaction, invoice: @customer2_invoices[4], result: "success")
    create(:transaction, invoice: @customer3_invoices[0], result: "failed")
    create(:transaction, invoice: @customer3_invoices[2], result: "success")
    create(:transaction, invoice: @customer3_invoices[4], result: "success")
    create(:transaction, invoice: @customer4_invoices[0], result: "failed")
    create(:transaction, invoice: @customer4_invoices[3], result: "success")
    create(:transaction, invoice: @customer5_invoices[0], result: "success")
    create(:transaction, invoice: @customer5_invoices[1], result: "failed")
    create(:transaction, invoice: @customer5_invoices[4], result: "success")
    create(:transaction, invoice: @customer6_invoices[0], result: "failed")
    create(:transaction, invoice: @customer6_invoices[1], result: "success")
    create(:transaction, invoice: @customer7_invoices[0], result: "success")
    create(:transaction, invoice: @customer7_invoices[3], result: "success")
    create(:transaction, invoice: @customer7_invoices[2], result: "failed")
    create(:transaction, invoice: @customer7_invoices[2], result: "success")
  end

  describe "Class methods" do
    it "returns all enabled merchants" do
      expect(Merchant.enabled).to eq([@merchant_1, @merchant_2, @merchant_3, @merchant_4])
    end

    it "returns all disabled merchants" do
      expect(Merchant.disabled).to eq([@merchant_5, @merchant_6, @merchant_7])
    end

    it "returns top 5 merchants by total revenue generated" do
      top_5_array = Merchant.top_5_merchants_by_total_revenue
      expect(top_5_array).to eq([@merchant_6, @merchant_2, @merchant_4, @merchant_5, @merchant_7])
      expect(number_to_currency(@merchant_6.total_revenue)).to eq("$4,348.36")
    end

    it "returns the top sales date for a given merchant" do
      expect(@merchant_1.best_day).to eq("Thursday, June 5, 2014")
      expect(@merchant_2.best_day).to eq("Tuesday, April 7, 1998")
      expect(@merchant_3.best_day).to eq("Friday, July 6, 1900")
      expect(@merchant_4.best_day).to eq("Friday, July 6, 1900")
      expect(@merchant_5.best_day).to eq("Monday, May 4, 1987")
      expect(@merchant_6.best_day).to eq("Sunday, July 6, 2003")
      expect(@merchant_7.best_day).to eq("Sunday, July 6, 2003")
    end
  end
end
