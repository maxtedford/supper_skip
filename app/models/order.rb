class Order < ActiveRecord::Base
  include AASM
  has_many :order_items
  has_many :items, through: :order_items
  has_many :restaurant_orders
  belongs_to :user

  validates :user, presence: true
  validates :address, presence: true, if: :delivery?

  before_save :calculate_total

  scope :past_orders, -> { where(status: [:ordered, :paid, :completed, :cancelled]) }

  aasm column: :status do
    # each state has a predicate method we can use to check status, like .in_cart?
    state :in_cart, initial: true
    state :ordered
    state :paid
    state :ready_for_preparation
    state :cancelled
    state :in_preparation
    state :ready_for_delivery
    state :out_for_delivery
    state :completed

    # events give us bang methods, like place! for changing order status
    event :place do
      transitions from: :in_cart, to: :ordered, guard: :no_retired_items?
    end

    event :pay do
      transitions from: :ordered, to: :paid
    end

    event :ready_for_prep do
      transitions from: [:paid], to: :ready_for_preparation
    end

    event :start_prep do
      transitions from: [:ready_for_preparation], to: :in_preparation
    end

    event :ready_for_delivery do
      transitions from: [:start_prep], to: :ready_for_delivery
    end

    event :start_delivery do
      transitions from: [:ready_for_delivert], to: :out_for_delivery
    end

    event :cancel do
      transitions from: [:ordered, :paid, :ready_for_preparation], to: :cancelled
    end

    event :complete do
      transitions from: :paid, to: :completed
    end
  end

  def pickup?
    !delivery
  end

  def editable?
    in_cart? || ordered? || paid?
  end

  def calculate_total
    self.total = items.sum(:price)
  end

  def update_quantities
    current_quantities = quantities
    items.each do |item|
      item.quantity = current_quantities[item.id].quantity
    end
  end

  def quantities
    items.group_by(&:id).inject({}) do |memo, (k, items)|
      memo[k] = items.first
      memo[k].quantity = items.count
      memo
    end
  end

  def decrease(item)
    order_items.find_by(item_id: item.id).destroy
    reload
    calculate_total
    update_quantities
  end

  def remove_item(item)
    order_items.where(item: item).joins(:item).destroy_all
    items.reload
    save!
    update_quantities
  end

  def increase(item)
    items << item
    items.reload
    save!
    update_quantities
  end

  def subtotal(item)
    quantity = quantities[item.id].quantity
    quantity * item.price
  end

  def no_retired_items?
    return true if order_items.retired.empty?
    order_items.retired.delete_all
    false
  end

  def group_by_restaurant
    items.group_by(&:restaurant)
  end
end
