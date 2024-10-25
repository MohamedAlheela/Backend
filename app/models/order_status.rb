class OrderStatus < ApplicationRecord
  belongs_to :order

  enum name: {
    waiting_for_delivery_to_washer: 0,
    delivered_to_washer: 1,
    queued_for_washing: 2,
    washing_in_progress: 3,
    washing_complete: 4,
    waiting_for_delivery_to_customer: 5,
    complete: 6
  }

  # Validations
  validates :name, presence: true, inclusion: { in: names.keys }
  validates :time, presence: true
  validates :note, length: { maximum: 500 }
end
