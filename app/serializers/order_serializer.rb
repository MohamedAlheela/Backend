class OrderSerializer
  include JSONAPI::Serializer

  attributes :latitude, :longitude, :address, :total_price, :deliverer_id, :customer_id, :delivery_time

  attribute :order_products do |order|
    OrderProductSerializer.new(order.order_products).serializable_hash[:data].map do |data|
      data[:attributes]
    end
  end

  attribute :order_statuses do |order|
    OrderStatusSerializer.new(order.order_statuses).serializable_hash[:data].map do |data|
      data[:attributes]
    end
  end
end
