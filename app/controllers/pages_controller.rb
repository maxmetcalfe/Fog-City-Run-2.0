class PagesController < ApplicationController

  def show
  end

  def count
  end

  def records
  end

  def safety
    render :layout => false
  end

  def shop
    @user_order = Order.where(:user_id => current_user.id).first
    # Only racers with 30 or more races can place an order.
    @user_shop_blocked = false
    if Result.where(:racer_id => current_user.racer_id).count <= 30
      @user_shop_blocked = true
    end
  end

end