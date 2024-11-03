class Order < ApplicationRecord
  belongs_to :deliverer, class_name: 'User', foreign_key: 'deliverer_id', optional: true
  # Associations
  belongs_to :country, optional: true
  belongs_to :deliverer, class_name: 'User', foreign_key: 'deliverer_id'
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products
  has_many :order_statuses, dependent: :destroy

  # Validations
  validates :latitude, :longitude, :address, :total_price, :delivery_time, presence: true
  validates :latitude, :longitude, numericality: true
  # Callbacks
  after_save :calculate_total_price
  after_create :create_order_status
  
  accepts_nested_attributes_for :order_products

  private

  def calculate_total_price
    self.total_price = order_products.joins(:product).sum(
      "quantity * (products.price * (1 - products.discount / 100.0))"
    )
    
    self.total_price += order_products.joins(:product).where(include_iron: true).sum(
      "quantity * (products.iron_price * (1 - products.discount / 100.0))"
    )
  end

  def create_order_status
    order_statuses.create!(name: :waiting_for_delivery_to_washer, time: Time.zone.now, order_id: id)
  end
end
