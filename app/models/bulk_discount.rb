class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  
  validates :percentage, presence: true
  validates :quantity, presence: true


end