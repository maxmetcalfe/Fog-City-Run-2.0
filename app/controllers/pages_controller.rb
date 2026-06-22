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
    elsif !filter.is_a? Integer
      filter =0
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


end