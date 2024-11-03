class User < ApplicationRecord
  # Associations
  belongs_to :country, optional: true
  has_many :orders, class_name: 'Order', foreign_key: 'customer_id', dependent: :destroy
  has_many :deliveries, class_name: 'Order', foreign_key: 'deliverer_id', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, deliverer: 1, admin: 2 }

  # Validations
  validates :first_name, :last_name, presence: true
  validates :phone_number, format: { with: /\A\d+\z/, message: 'only allows numbers' }, allow_blank: true
  validates :photo, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL' }, allow_blank: true
  validates :role, inclusion: { in: roles.keys }
  validates :latitude, :longitude, numericality: true, allow_blank: true
  validates :address, length: { maximum: 255 }
end
