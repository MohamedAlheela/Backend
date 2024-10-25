class OrderSerializer
  include JSONAPI::Serializer

  attributes :latitude, :longitude, :address, :total_price, :deliverer_id, :customer_id, :delivery_time

  attribute :order_products do |order|
    order.order_products.map do |order_product|
      {
        product_id: order_product.product_id,
        quantity: order_product.quantity,
        include_iron: order_product.include_iron
      }
    end
  end
end
