class OrderProductSerializer
  include JSONAPI::Serializer

  attributes :product_id, :quantity, :include_iron
end
