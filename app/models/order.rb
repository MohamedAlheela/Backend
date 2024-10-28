class Order < ApplicationRecord
  # Associations
  belongs_to :country  
  belongs_to :deliverer, class_name: 'User', foreign_key: 'deliverer_id'
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products
  has_many :order_statuses, dependent: :destroy

  validates :latitude, :longitude, :address, :total_price, :delivery_time, presence: true
  validates :latitude, :longitude, numericality: true
  validate :total_price_calculation

  private

  def total_price_calculation
    self.total_price = order_products.sum("quantity * products.price")
    self.total_price += order_products.joins(:product).where(include_iron: true).sum("quantity * products.iron_price")
  end
end
