class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants
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

  def applicable_discount
    select('discounts.*, invoice_items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_price, 
    (sum(invoice_items.quantity * invoice_items.unit_price) * discounts.percentage / 100) as discount_total_off, 
    sum(invoice_items.quantity * invoice_items.unit_price) - (sum(invoice_items.quantity * invoice_items.unit_price) * discounts.percentage / 100) as discounted_total')
    .where('invoice_items.quantity >= discounts.quantity')
    .group('discounts.id, invoice_items.id')
    .order('discounts.percentage asc')


  end
end


#available_discount = invoice[0].discounts.where("invoice_items.quantity >= discounts.quantity")

# available_discount = invoice[0].discounts.select('discounts.*, invoice_items.*, sum(invoice_items.quantity * invoice_ite
# ms.unit_price) as total_price, (sum(invoice_items.quantity * invoice_items.unit_price) * discounts.percentage / 100) as discount_total_of
# f, sum(invoice_items.quantity * invoice_items.unit_price) - (sum(invoice_items.quantity * invoice_items.unit_price) * discounts.percentag
# e / 100) as discounted_total').where('invoice_items.quantity >= discounts.quantity').group('discounts.id, invoice_items.id').order('disco
# unts.percentage asc')