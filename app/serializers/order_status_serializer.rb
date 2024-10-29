class OrderStatusSerializer
  include JSONAPI::Serializer
  attributes :time, :note, :name
end
