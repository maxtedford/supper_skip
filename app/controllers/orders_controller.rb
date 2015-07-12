class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.past_orders
  end

  def show
    @order = current_user.orders.where(id: params[:id]).take
    if @order
      @order.update_quantities
      render :show
    else
      flash[:error] = "You may only view your own orders"
      redirect_to root_path
    end
  end

  def edit
    @order = @cart.order
  end

  def update
    @order = @cart.order
    if @order.update(order_update_params)
      @order.place! if @order.in_cart?
      grouped_rest_orders = @order.order_items.group_by {|order_item| order_item.restaurant}
      grouped_rest_orders.map do |rest, order_items|
        rest_order = RestaurantOrder.create(restaurant_id: rest.id)
        order_items.map { |order_item| order_item.update_attributes!(restaurant_order_id: rest_order.id)}
      end
      redirect_to @order
    else
      redirect_to edit_order_path
      flash[:errors] = "You need an address if you want delivery"
      flash[:errors] = @order.errors.map {|attr, msg| "#{attr}: #{msg}" }.join("\n")
    end
  end

  private

  def order_update_params
    params.require(:order).permit(:address, :delivery)
  end
end
