require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product, price: 100) }

  describe '#add_tax_price' do
    it '税込価格を返すこと' do
      expect(product.add_tax_price).to eq 110
    end
  end
end
