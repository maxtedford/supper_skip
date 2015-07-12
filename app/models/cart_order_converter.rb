class CartOrderConverter
  def self.convert(session_cart, user)
    new.convert(session_cart, user)
  end

  def convert(session_cart, user)
    require 'pry';binding.pry
    order = Order.create!(user: user)
    items = Item.where(id: session_cart.keys)
    items.each do |item|
      create_order_items(session_cart, item, order)
    end
    order
  end

  def create_order_items(session_cart, item, order)
    quantity = session_cart[item.id]
    order_items = []
    quantity.times do
      order_items << OrderItem.create!(item: item, order: order)
    end
    #roh = order_items.group_by {|oi| oi.restaurant if oi.restaurant}
    
    #ros = roh.each {|rest, oi| RestaurantOrder.create(restaurant_id: rest.id) }
  end
end
