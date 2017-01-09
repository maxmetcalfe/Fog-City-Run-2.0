class RacesController < ApplicationController

  @races = Race.includes(:race)

  # Show all races
  def index
    @races = Race.all
    @races_to_show = @races.joins(:results).group("race_id").count(:race_id).sort_by { |k| k[0]}.reverse
    @upcoming_races_to_show = Race.where("date >= ?", Date.today)
    if params[:search]
      @races = Race.search(params[:search])
    end
  end

  # Show race by id
  def show
    @race = Race.find(params[:id])
    @race_results = @race.results.order(:rank)
    if @race_results.length > 0
      @has_results = true
    else
      @has_results = false
    end
    @start_items = StartItem.where(:race_id=>params[:id]).order(:bib)
    if @start_items.length > 0
      @has_start_items = true
    else
      @has_start_items = false
    end
    @current_user_registered = is_current_user_registered()
    @race_in_progess = race_in_progess
    # Starting time for timer
    if @has_start_items
      @start_time = @start_items[0].start_time.to_time.utc.to_i
    end
  end

  # Delete race
  def destroy
    @race = Race.find(params[:id])
    racer_ids = Result.where(:race_id => @race.id).pluck(:racer_id)
    @race.results.destroy_all
    @race.destroy
    update_race_count()
    update_streak_calendar(racer_ids)

    redirect_to races_path
  end

  # Edit race
  def edit
    @race = Race.find(params[:id])
  end

  # Create race
  def create
  	@race = Race.new(race_params)
    if @race.save
      update_race_count()
      redirect_to @race
    else
      render 'new'
    end
  end

  # New race
  def new
  	@race = Race.new
  end

  # Update race
  def update
    @race = Race.find(params[:id])
    if @race.update(race_params)
      update_race_count()
      redirect_to @race
    else
      render 'edit'
    end
  end

  # import CSV
  def import
    Race.import(params[:file])
    redirect_to races_url, notice: "Races imported successfully"
  end

  def send_results_email
    results = Result.where(:race_id => params[:race_id])
    for r in results
      @user = User.where(:racer_id => r.racer_id)
      # Send email if we find a user for the racer
      if @user and @user.first.try(:email)
        ResultMailer.results_email(r, @user.first.email).deliver
      else
        puts "Could not send an email for this result: " + r.to_s
      end
    end
    redirect_to races_path
    flash[:success] = "Emails have been sent."
  end

  def is_current_user_registered
    if current_user and StartItem.where(:race_id => @race.id).pluck(:racer_id).include? current_user.racer_id
      return true
    else
      return false
    end
  end

  # Start race. Set start_time to DateTime.now for this race's start items.
  def start_race
    @race = Race.find(params[:id])
    StartItem.where('race_id = ?', @race.id).update_all(start_time: DateTime.now)
    @race.update(in_progress: true)
    redirect_to @race
  end

  # Stop race.
  def stop_race
    @race = Race.find(params[:id])
    StartItem.where('race_id = ?', @race.id).update_all(start_time: DateTime.now)
    @race.update(in_progress: false)
    redirect_to @race
  end

  # Check if race is in progress
  def race_in_progess
    @race = Race.find(params[:id])
    return @race.in_progress
  end

  #Permit parameters when creating race
  private

  def race_params
    params.require(:race).permit(:date)
  end
end