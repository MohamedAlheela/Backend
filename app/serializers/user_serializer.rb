class UserSerializer
  include JSONAPI::Serializer

  attributes :first_name, :last_name, :email, :phone_number, :photo, :role, :latitude, :longitude, :address, :country_id
end
