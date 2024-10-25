class OrderStatusSerializer
  include JSONAPI::Serializer
  attributes :order_id, :time, :note, :name
end
