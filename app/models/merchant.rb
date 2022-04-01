class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  validates_presence_of(:name)

  def self.search(params)
    where("name ILIKE ?", "%#{params}%").order(:name)
  end
end 