class CartOrderConverter
  def self.convert(session_cart, user)
    new.convert(session_cart, user)
  end

  def convert(session_cart, user)
    order = Order.create!(user: user)
    items = Item.where(id: session_cart.keys)
    items.each do |item|
      rest_order = RestaurantOrder.create(restaurant_id: item.restaurant_id)
      create_order_items(session_cart, item, order, rest_order)
    end
    order
  end

  def create_order_items(session_cart, item, order, rest_order)
    quantity = session_cart[item.id]
    quantity.times do
      OrderItem.create!(item: item, order: order, restaurant_id: item.restaurant.id, restaurant_order: rest_order)
    end
  end
end
