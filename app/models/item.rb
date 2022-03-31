class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true, format: {with: /[a-zA-Z]/}
  validates_presence_of :description
  validates :unit_price, numericality: true
end 