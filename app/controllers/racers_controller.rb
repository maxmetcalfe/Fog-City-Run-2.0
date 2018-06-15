require "#{Rails.root}/lib/utils"

class RacersController < ApplicationController

  before_filter :must_be_admin, only: [:edit]

  def autocomplete_racer
    term = params[:term]
    racers = Racer.where(
        'LOWER(first_name) LIKE LOWER(?) OR LOWER(last_name) LIKE LOWER(?)',
        "%#{term}%", "%#{term}%"
        ).order(:id).all
    respond_to do |format|
      format.html
      format.json {
        puts render :json => racers.map { |racer| { label: racer.first_name + " " + racer.last_name, value: racer.id } }
      }
    end
  end

  # Show all racers
  def index
    @racers = Racer.paginate(:page => params[:page])
    if params[:search]
      @racers = Racer.search(params[:search]).paginate(:page => params[:page])
    end
  end

  # Show racer by id
  def show
    @racer = Racer.find(params[:id])
    @user = User.where(:racer_id => @racer.id).first
    @longest_streak_for_view = "(" + @racer.longest_streak_array[0].to_s + " through " + @racer.longest_streak_array[-1].to_s + ")"
    if @racer.current_streak_array.length == 0
      @current_streak_for_view = "(no current streak)"
    else
      @current_streak_for_view = "(" + @racer.current_streak_array[0].to_s + " through " + @racer.current_streak_array[-1].to_s + ")"
    end
    @results = @racer.results.includes(:race).order(race_id: :desc)
    @racer_data = @results.map {|result| {:date => result.race.date, :time => to_seconds(result.time), :group_name => result.group_name } }.to_json.html_safe
    if current_user
    @user_order = Order.where(:user_id => current_user.id).first
    end
    if @results.length > 0
      @has_results = true
    end
  end

  # Delete racer
  def destroy
    @racer = Racer.find(params[:id])
    @racer.destroy
    redirect_to racers_path
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

  # Create racer
  def create
    @racer = Racer.new(racer_params)
    @racer.id = Racer.maximum(:id).next
    next_race = Race.where("date >= ?", Date.today).first
    if @racer.save && next_race
      full_name = @racer.first_name + " "+ @racer.last_name
      redirect_to new_start_item_path(:race_id => next_race.id, :racer => full_name)
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

  # Manually run update_streak_calendar() for a particular racer
  def refresh_streak
    racer = Racer.find(params[:id])
    update_streak_calendar(racer)
    redirect_to :back
  end

  # Permit parameters when creating article
  private
  def racer_params
    params.require(:racer).permit(:first_name, :last_name)
  end
end