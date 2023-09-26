class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  validates :customer_id, presence: true
  validates :status, presence: true

  enum :status,["in progress", "completed", "cancelled"]

  def self.incomplete_invoices
    Invoice
    .joins(:invoice_items)
    .select('invoices.*')
    .where.not('invoice_items.status = ?', 2)
    .group('invoices.id')
    .order(:created_at)
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity") / 100.0
  end

  def discounted_revenue
    invoice_items.each.sum do |item|
      if !item.available_discounts.empty?
        item.available_discounts[0].discounted_total
      else
        item.quantity * item.unit_price
      end
    end
  end

  def possible_discounts
  BulkDiscount
  .select('bulk_discounts.*, invoice_items.*, sum((invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage / 100) as discount_total_off')
  .joins(:invoice_items)
    .where('invoice_items.invoice_id = ?', self.id)
    .where('bulk_discounts.percentage = (SELECT MAX(bulk_discounts.percentage) 
          FROM bulk_discounts 
          WHERE bulk_discounts.merchant_id = merchants.id 
          AND bulk_discounts.quantity <= invoice_items.quantity)')
    .where('invoice_items.quantity >= bulk_discounts.quantity')
    .group('bulk_discounts.id, invoice_items.id')
    .order('bulk_discounts.percentage ASC')
  end

  def applicable_discount
    self.possible_discounts.sum { |discount| discount.discount_total_off }
  end

  # def calculated_discount
  #   self.invoice_items.joins(:bulk_discounts).select('invoice_items.*, sum((invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage / 100) as discount_total_off')
  #   .where('invoice_items.invoice_id = ? AND invoice_items.quantity >= bulk_discounts.quantity', self.id)
  #   .where('bulk_discounts.percentage = (SELECT MAX(bulk_discounts.percentage) 
  #         FROM bulk_discounts 
  #         WHERE bulk_discounts.merchant_id = merchants.id 
  #         AND bulk_discounts.quantity <= invoice_items.quantity)')
  #   .group('invoice_items.id')
  # end
end


