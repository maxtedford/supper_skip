class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item
  belongs_to :restaurant_order
  belongs_to :restaurant

  after_create :update_order

  scope :retired, -> { joins(:item).where(items: { retired: true }) }

  private

  def update_order
    order.save
  end
end
