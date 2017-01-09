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
      'GROUP BY extract(year from p.date) '\
      'ORDER by average_count DESC;'
    @output = connection.exec_query(query)
    # @racer_count_series = Racer.first.results.joins(:race).where(group_name: "ALL").map {|result| [Race.find(result.race_id).date, to_seconds(result.time)] }
    @racer_count_series = gather_racer_count_series
  end

  # Create series for racer count plot.
  def gather_racer_count_series
    open_dates = []
    data = []
    open_dates = open_dates.push '2013-01-16'.to_date
    while open_dates[-1] < Date.today - 1.week
      open_dates = open_dates.push open_dates[-1].advance(:weeks => 1)
    end
    # Set default filter for initial page load
    if params[:filter].nil?
      filter = 80
    else
      filter = params[:filter]
    end
    for r in Racer.where("race_count >= ?", filter)
      races_run = r.results.joins(:race).map {|result| Race.find(result.race_id).date }
      series_name = r.first_name + " " + r.last_name[0] + "."
      race_count = 0
      series_data = []
      for o in open_dates
        for r in races_run
          if o == r
            race_count = race_count + 1
            series_data.push [o,race_count]
          else
            series_data.push [o,race_count]
          end
        end
      end
    data << {name: series_name, data: series_data}
    end
    return data
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