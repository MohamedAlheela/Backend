class CountrySerializer
  include JSONAPI::Serializer

  attributes :name, :code, :currency
end
