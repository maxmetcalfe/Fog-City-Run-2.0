class StartItemsController < ApplicationController

  # Show all start_items
  def index
    @start_items = StartItem.all
  end

  # Show start_item by id
  def show
    @start_item = StartItem.find(params[:id])
  end

  # Delete start_item
  def destroy
    @start_item = StartItem.find(params[:id])
    race = Race.find(@start_item.race_id)
    @start_item.destroy
    redirect_to race
  end

  # Edit start_item
  def edit
    @start_item = StartItem.find(params[:id])
  end

  # Create start_item
  def create
    @start_item = StartItem.new(start_item_params)
    @start_item.start_time = DateTime.now
    @race = Race.find(@start_item.race_id)
    existing_start_item = StartItem.where(:racer_id => @start_item.racer_id, :race_id => @start_item.race_id)
  
    if existing_start_item.length == 1
      to_edit = existing_start_item.first
      to_edit.update(bib: start_item_params[:bib], group: start_item_params[:group])
      to_edit.save
    else
      if @start_item.save
        redirect_to race_path(@race)
      else
        render 'new'
      end
    end
  end

  # New start_item
  def new
    @start_item = StartItem.new
    @likely_racers = get_likely_racers(params[:race_id])
  end

  # Update start_item
  def update
    @start_item = StartItem.find(params[:id])
    race = Race.find(@start_item.race_id)
    if @start_item.update(start_item_params)
      redirect_to race_path(race)
    else
      render 'edit'
    end
  end

  # Stop race. Set finish_time
  def collect_time
    @start_item = StartItem.find(params[:id])
    @start_item.update(end_time: DateTime.now, finished: true)
    @race = Race.find(@start_item.race_id)
    finish_time = from_seconds(@start_item.end_time - @start_item.start_time)
    existing_result = Result.where(:racer_id => @start_item.racer_id, :race_id => @start_item.race_id)
    if existing_result.length == 1
      to_edit = existing_result.first
      to_edit.update(time: finish_time)
      to_edit.save!
    else
      result = Result.create(:rank => 0, :group_name => @start_item.group, :bib => @start_item.bib, :racer_id => @start_item.racer_id, :race_id => @start_item.race_id, :time => finish_time)
      result.save!
    end
    validate_ranks(@race.id)

    # HACK / TO DO: We can speed this up by avoiding another call to the DB.
    result = to_edit || result
    @racer = Racer.find(result.racer_id)
    @result = Result.find(result.id)

    # Call collect_time.js.erb
    respond_to do |format|
      format.json { render json: @result }
      format.js
    end
  end
  
  # Get a list of likely racers for a race.
  # Likely racers are the top 12 racers with more than 10 races OR
  # a current streak of more than 1, excluding those already registered.
  def get_likely_racers(race_id)
    already_registered = StartItem.where(:race_id => race_id).pluck(:racer_id)
    if already_registered.length > 0
      likely_racers = Racer.where(["(race_count > ? OR current_streak > ?) AND id not in (?)", 10, 1, already_registered]).order(race_count: :desc).first(12)
    else
      likely_racers = Racer.where(["race_count > ? OR current_streak > ?", 10, 1]).order(race_count: :desc).first(12)
    end
    return likely_racers
  end

  private

  def start_item_params
    params.require(:start_item).permit(:race_id, :racer_id, :bib, :group)
  end
end