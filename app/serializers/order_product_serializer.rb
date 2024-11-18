class OrderProductSerializer
  include JSONAPI::Serializer

  attributes :product_id, :quantity, :include_iron

  attribute :product_name do |object|
    object.product.name
  end  
end
