require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '::search' do
      it 'returns exact match' do
        merchant1 = create(:merchant, name: 'Bob Belcher')

        expect(Merchant.search('Bob Belcher')).to eq([merchant1])
      end
      
      it 'returns similar matches' do
        merchant1 = create(:merchant, name: 'Bob Belcher')
        merchant2 = create(:merchant, name: 'Bob Vance')
        
        expect(Merchant.search('Bob')).to eq([merchant1, merchant2])
      end

      it 'is not case sensitive' do
        merchant1 = create(:merchant, name: 'Bob Belcher')
        merchant2 = create(:merchant, name: 'Bob Vance')

        expect(Merchant.search('BOB')).to eq([merchant1, merchant2])
        expect(Merchant.search('bob')).to eq([merchant1, merchant2])
      end

      it 'returns matches in alphabetical order' do
        merchant1 = create(:merchant, name: 'Bob Belcher')
        merchant2 = create(:merchant, name: 'Bob Vance')

        expect(Merchant.search('Bob')).to eq([merchant1, merchant2])
      end
    end
  end
end