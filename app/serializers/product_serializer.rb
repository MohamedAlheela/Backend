class ProductSerializer
  include JSONAPI::Serializer
  attributes :name, :price, :iron_price, :discount
end
