class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
  validates :invoice_id, presence: true
  validates :item_id, presence: true
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  enum :status,["packaged", "pending", "shipped"]

  def unit_price_to_decimal
    unit_price / 100.0
  end

  # def applicable_discount
  #   discounts.select('*, discounts.*, sum(quantity * unit_price) as total_price, 
  #   (sum(quantity * unit_price) * discounts.percentage / 100) as discount_total_off, 
  #   sum(quantity * unit_price) - (sum(quantity * unit_price) * discounts.percentage / 100) as discounted_total')
  #   .where('quantity >= discounts.quantity')
  #   .group('discounts.id, invoice_items.id')
  #   .order('discounts.percentage asc')
  # end
  
  def available_discounts 
    self.bulk_discounts
    .joins(:invoice_items)
    .select('bulk_discounts.*, 
    sum(invoice_items.quantity * invoice_items.unit_price) as total_price,
    (sum(invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage / 100) as discount_total_off, 
    sum(invoice_items.quantity * invoice_items.unit_price) - (sum(invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage / 100) as discounted_total')
    .where('bulk_discounts.quantity <= ? AND invoice_items.id = ?', self.quantity, self.id)
    .group('bulk_discounts.id').order('bulk_discounts.percentage desc')
    .limit(1)
  end
end
# available_discounts = item.discounts.select('discounts.*, sum(quantity * unit_price) - (sum(quantity * unit_price) * dis
# counts.percentage / 100) as discounted_total').where('discounts.quantity <= ?', item.quantity).group('discounts.id').order('discounts.per
# centage desc')


