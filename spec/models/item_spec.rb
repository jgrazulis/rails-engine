require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'class methods' do
    describe '::name_search' do
      it 'returns an exact match' do
        item = create(:item, name: "blonde roast coffee")

        expect(Item.name_search("blonde roast coffee")).to eq([item])
      end

      it 'returns near matches' do
        item_1 = create(:item, name: "blonde roast coffee")
        item_2 = create(:item, name: "not coffee")

        expect(Item.name_search("coffee")).to eq([item_1, item_2])
      end

      it 'returns near matches in alphabetical and unicode case order' do
        item_1 = create(:item, name: "blonde roast coffee")
        item_2 = create(:item, name: "not coffee")
        item_3 = create(:item, name: "dark roast coffee")

        expect(Item.name_search("coffee")).to eq([item_1, item_3, item_2])
      end

      it 'is not case sensitive' do
        item_1 = create(:item, name: "blonde roast coffee")
        item_2 = create(:item, name: "not coffee")

        expect(Item.name_search("COFFEE")).to eq([item_1, item_2])
        expect(Item.name_search("coffee")).to eq([item_1, item_2])
      end
    end

    describe '::min_price_search' do
      it 'returns all items larger than or equal to a given threshold' do
        item_1 = create(:item, unit_price: 9.99)
        item_2 = create(:item, unit_price: 9.98)
        item_3 = create(:item, unit_price: 5.98)
        item_4 = create(:item, unit_price: 1.00)
        item_5 = create(:item, unit_price: 50.00)

        expect(Item.min_price_search(9.99)).to eq([item_1, item_5])
      end
    end

    describe '::max_price_search' do
      it 'returns all items less that a given threshold' do
       item_1 = create(:item, unit_price: 9.99)
       item_2 = create(:item, unit_price: 9.98)
       item_3 = create(:item, unit_price: 5.98)
       item_4 = create(:item, unit_price: 1.00)
       item_5 = create(:item, unit_price: 50.00)
       
       expect(Item.max_price_search(1.00)).to eq([item_4])
      end
    end

    describe '::range_search' do
      it 'returns items within a given range' do
        item_1 = create(:item, unit_price: 9.99)
        item_2 = create(:item, unit_price: 9.98)
        item_3 = create(:item, unit_price: 5.98)
        item_4 = create(:item, unit_price: 1.00)
        item_5 = create(:item, unit_price: 50.00)

        expect(Item.range_search(5.00, 20.00)).to eq([item_1, item_2, item_3])
      end
    end
  end
end