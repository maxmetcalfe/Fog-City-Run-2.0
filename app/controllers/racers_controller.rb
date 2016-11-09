class RacersController < ApplicationController

  # Show all racers
  def index
    @racers = Racer.all
    if params[:search]
      @racers = Racer.search(params[:search])
    end
    @output = []
    for r in @racers
      long_streak = get_streak_calendar(r)[0]
      race_count = Result.where(:racer_id => r.id).count
      @output.push [r, long_streak, race_count]
    end
  end

  # Convert raw time to seconds to use in ChartKick
  def to_seconds(raw_time)
    time_split = raw_time.split(":")
    hours = time_split[0]
    minutes = time_split[1]
    seconds = time_split[2]
    return hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
  end

  def get_streak_calendar(racer)
    open_dates = []
    @open_dates = open_dates.push '2013-01-16'.to_date
    while @open_dates[-1] < Date.today - 1.week
      @open_dates = @open_dates.push @open_dates[-1].advance(:weeks => 1)
    end
    @races_run = @racer.results.joins(:race).map {|result| Race.find(result.race_id).date }
    @longest_streak_count = 0
    @streak = []
    @current_streak = 0
    for o in @open_dates
      @found = 0
      for r in @races_run
        if o == r
          @streak = @streak.push r
          if @streak.length > @longest_streak_count
            @longest_streak_count = @streak.length
          end
          @found = 1
          if @open_dates[-1] == @streak[-1]
            @current_streak = @streak.length
          end
        end
      end
      if @found == 0
        @streak = []
      end
    end
    return @longest_streak_count, @current_streak_count
  end

  # Show racer by id
  def show
    @racer = Racer.find(params[:id])
    @results_to_show = @racer.results.joins(:race).where(group_name: "ALL").map {|result| [Race.find(result.race_id).date, to_seconds(result.time)] }
    @longest_streak_count, @current_streak_count = get_streak_calendar(params[:id])
    if current_user
    @user_order = Order.where(:user_id => current_user.id).first
    end
  end

  # Delete racer
  def destroy
    @racer = Racer.find(params[:id])
    @racer.destroy
  end

  # Edit racer
  def edit
    @racer = Racer.find(params[:id])
  end

  # claim this racer
  def claim_this_racer
    racer = Racer.find(params[:id])
    racer = Racer.find(params[:id])
  end

  # Create article
  def create
  	@racer = Racer.new(racer_params)
    if @racer.save
      redirect_to @racer
    else
      render 'new'
    end
  end

  # New racer
  def new
  	@racer = Racer.new
  end

  # Update racer
  def update
    @racer = Racer.find(params[:id])
    if @racer.update(racer_params)
      redirect_to @racer
    else
      render 'edit'
    end
  end

  # import CSV
  def import
    Racer.import(params[:file])
    redirect_to racers_url, notice: "Racers imported successfully"
  end

  # Permit parameters when creating article
  private
  def racer_params
    params.require(:racer).permit(:first_name, :last_name)
  end
end