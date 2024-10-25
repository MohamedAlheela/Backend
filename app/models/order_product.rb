class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :include_iron, inclusion: { in: [true, false] }
  validates :product_id, uniqueness: { scope: :order_id }  
end
