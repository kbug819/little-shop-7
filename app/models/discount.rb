class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :transactions, through: :invoices
  validates :percentage, presence: true
  validates :quantity, presence: true


end