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
    hats = ["The Divis", "The Buchanan", "The Filbert St. Hop", "The Lombard Gate"]
    shirts = ["4YT-Shirt"]
    @order = Order.new(order_params)
    # Only allow user to order a single hat
    @user_orders = Order.where(:user_id => current_user.id)
    hat_orders = @user_orders.select{|x| hats.include? x.item}
    shirt_orders = @user_orders.select{|x| shirts.include? x.item}

    # Only allow the user to order a single shirt
    if shirt_orders.size > 0 and shirts.include? order_params[:item]
      Order.destroy(shirt_orders.map(&:id))
    end

    # Only allow the user to order a single hat
    if hat_orders.size > 0 and hats.include? order_params[:item]
      Order.destroy(hat_orders.map(&:id))
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
      redirect_to orders_path
    else
      render 'edit'
    end
  end

  private
  def order_params
    params.require(:order).permit(:user_id, :item, :quantity, :delivered, :size)
  end
end