class StaffOrderAssigner
  def initialize(order, user, status)
    @order  = order
    @user   = user
    @status = status
  end

  def check_order_status
    if prepare? || deliver?
      @order.update(staff_id: @user.id)
    end
  end

  def prepare?
    @status == 'in_preparation'
  end

  def deliver?
    @status == 'out_for_delivery'
  end
end


