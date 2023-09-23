class Discount < ApplicationRecord
  belongs_to :merchant

  validates :percentage, presence: true
  validates :quantity, presence: true


end