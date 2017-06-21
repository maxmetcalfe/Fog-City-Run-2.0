class RacersController < ApplicationController

  def autocomplete_racer
    term = params[:term]
    racers = Racer.where(
        'LOWER(first_name) LIKE LOWER(?) OR LOWER(last_name) LIKE LOWER(?)',
        "%#{term}%", "%#{term}%"
        ).order(:id).all
    respond_to do |format|
      format.html
      format.json {
        puts render :json => racers.map { |racer| racer.first_name + " " + racer.last_name }
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
    longest_streak, current_streak = update_streak_calendar([@racer.id])
    @longest_streak_for_view = "(" + longest_streak[0].to_s + " through " + longest_streak[-1].to_s + ")"
    if current_streak.length == 0
      @current_streak_for_view = "(no current streak)"
    else
      @current_streak_for_view = "(" + current_streak[0].to_s + " through " + current_streak[-1].to_s + ")"
    end
    @results_for_graph = @racer.results.joins(:race).where(group_name: "ALL").map {|result| {:date => Race.find(result.race_id).date, :time => to_seconds(result.time) } }.to_json.html_safe
    if current_user
    @user_order = Order.where(:user_id => current_user.id).first
    end
    if @results_for_graph.length > 0
      @has_results = true
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
    @racer.id = Racer.maximum(:id).next
    if @racer.save
      next_race = Race.where("date >= ?", Date.today).first
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

  # Permit parameters when creating article
  private
  def racer_params
    params.require(:racer).permit(:first_name, :last_name)
  end
end