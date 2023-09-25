require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe BulkDiscount, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "validations" do
    it { should validate_presence_of :percentage}
    it { should validate_presence_of :quantity}
  end
end