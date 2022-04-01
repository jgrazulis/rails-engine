class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true, format: {with: /[a-zA-Z]/}
  validates_presence_of :description
  validates :unit_price, numericality: true

  def self.name_search(params)
    where("name ILIKE ?", "%#{params}%").order(:name)
  end

  def self.min_price_search(price)
    where("unit_price >= ?", "#{price}")
  end

  def self.max_price_search(price)
    where("unit_price <= ?", "#{price}")
  end

  def self.range_search(min, max)
    where("unit_price >= #{min} AND unit_price <= #{max}")
  end
end 