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
    if current_user
      @user_order = Order.where(:user_id => current_user.id).first
      # Only racers with 30 or more races can place an order.
      @user_shop_blocked = false
      if Result.where(:racer_id => current_user.racer_id).count <= 15
        @user_shop_blocked = true
      end
    end
    @total_orders = Order.all.count
    @eligible_users = Racer.where("race_count >= ?", 15).count
    @percent_valid = ((@total_orders.to_f / @eligible_users.to_f) * 100).to_i
  end

end