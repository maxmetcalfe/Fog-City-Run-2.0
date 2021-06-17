class PagesController < ApplicationController

  def show
  end

  # Get average racer count by year (for use in pages/count)
  def count
    connection = ActiveRecord::Base.connection
    query = 'SELECT extract(year from p.date), round(avg(p.count), 2) as average_count '\
      'FROM'\
      '(SELECT races.date, count(*) as count '\
      'FROM results '\
      'LEFT JOIN races on (results.race_id = races.id) '\
      'GROUP BY races.date) as p '\
      'GROUP BY extract(year from p.date)'\
      'ORDER by extract(year from p.date) DESC;'
    @output = connection.exec_query(query)

    if params[:filter].nil?
      filter = 80
    else
      filter = params[:filter]
    end

    @racer_count_series = []

    for r in Racer.where("race_count >= ?", filter)
      begin
        if r.count_data
          json_data = JSON.parse(r.count_data)
        end
      rescue JSON::ParserError => e
        puts "ERROR: failed to parse count_data for racer: " + r.id.to_s + " - " + r.first_name + " " + r.last_name
      end
      @racer_count_series.push({ name: r.first_name[0] + ". " + r.last_name, data: json_data })
    end
  end

  def records
  end

  def safety
    render :layout => false
  end

  def shop
  hats = ["The Divis", "The Buchanan", "The Filbert St. Hop", "The Lombard Gate"]
  shirts = ["4YT-Shirt"]
    if current_user
      @user_orders = Order.where(:user_id => current_user.id)
      # Force to nil if none exist.
      if @user_orders.size == 0
        @user_orders = nil
      end
      # Only racers with 30 or more races can place an order.
      @user_shop_blocked = false
      if Result.where(:racer_id => current_user.racer_id).count <= 15
        @user_shop_blocked = true
      end
    end
    @total_hat_orders = Order.all.select{|x| hats.include? x.item}.size
    @eligible_users = Racer.where("race_count >= ?", 15).count
    @percent_valid = ((@total_hat_orders.to_f / @eligible_users.to_f) * 100).to_i
  end

end