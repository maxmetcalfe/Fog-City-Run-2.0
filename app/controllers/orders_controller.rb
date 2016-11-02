class OrdersController < ApplicationController

  # Show all orders
  def index
    @orders = Order.all
  end

  # Show order by id
  def show
    @order = Order.find(params[:id])
  end

  # Delete order
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to shop_path
  end

  # Edit order
  def edit
    @order = Order.find(params[:id])
  end

  # New orders
  def new
  	@order = Order.new
  end

  # Create order
  def create
    @order = Order.new(order_params)
    @user_order = Order.where(:user_id => current_user.id).first
    if !@user_order.nil?
      Order.destroy(@user_order.id)
    end
    # If someone tries to order something for someone else. Change user back to current_user
    if @order.user_id != current_user.id
      @order.user_id = current_user.id
    end
    if @order.save  
      redirect_to shop_path
    else
      render 'new'
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private
  def order_params
    params.require(:order).permit(:user_id, :item, :quantity, :delivered, :size)
  end
end