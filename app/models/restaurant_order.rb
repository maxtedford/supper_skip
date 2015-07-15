class RestaurantOrder < ActiveRecord::Base
  include AASM
  belongs_to :restaurant
  belongs_to :order
  has_many :order_items
  has_many :items, through: :order_items

  enum status: %w(ordered ready_for_preparation cancelled in_preparation ready_for_delivery out_for_delivery completed)

  aasm column: :status do
    # each state has a predicate method we can use to check status, like .in_cart?
    #state :in_cart, initial: true
    state :ordered, initial: true
    state :ready_for_preparation
    state :cancelled
    state :in_preparation
    state :ready_for_delivery
    state :out_for_delivery
    state :completed

    # events give us bang methods, like place! for changing order status
    #event :place do
     # transitions from: :in_cart, to: :ordered, guard: :no_retired_items?
    #end

    event :ready_for_preparation do
      transitions from: :ordered, to: :ready_for_preparation
    end

    event :cancel do
      transitions from: [:ordered, :ready_for_preparation], to: :cancelled
    end

    event :in_preparation do
      transitions from: [:ready_for_preparation], to: :in_preparation
    end

    event :ready_for_delivery do
      transitions from: [:in_preparation], to: :ready_for_delivery
    end

    event :out_for_delivery do
      transitions from: [:ready_for_delivery], to: :out_for_delivery
    end

    event :complete do
      transitions from: :out_for_delivery, to: :completed
    end
  end

  def quantities
    items.group_by(&:id).inject({}) do |memo, (k, items)|
      memo[k] = items.first
      memo[k].quantity = items.count
      memo
    end
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

  def update_status(params)
    case params[:status]
    when 'pay'
      self.pay!
    when 'ready_for_preparation'
      self.ready_for_preparation!
    when 'in_preparation'
      self.in_preparation!
    when 'ready_for_delivery'
      self.ready_for_delivery!
    when 'out_for_delivery'
      self.out_for_delivery!
    when 'complete'
      self.complete!
    when 'cancel'
      self.cancel!
    end
  end

  def sanitize_status
    self.status.gsub('_', ' ').capitalize
  end
end


