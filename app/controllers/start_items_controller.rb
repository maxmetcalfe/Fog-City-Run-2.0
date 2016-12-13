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
    @start_item.destroy
    redirect_to :action => 'index'
  end

  # Edit race
  def edit
    @race = StartItem.find(params[:id])
  end

  # Create start_item
  def create
  	@start_item = StartItem.new(start_item_params)
    if @start_item.save
      redirect_to races_path
    else
      render 'new'
    end
  end

  # New start_item
  def new
    @start_item = StartItem.new
  end

  # Update race
  def update
    @start_item = StartItem.find(params[:id])
    if @start_item.update(start_item_params)
      redirect_to @start_item
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
    @result = Result.create(:rank => 0, :id => Result.maximum(:id).next, :group_name => "ALL", :bib => @start_item.bib, :time => Date.today, :racer_id => @start_item.racer_id, :race_id => @start_item.race_id, :time => finish_time)
    @result.save
    validate_ranks(@race.id)
    redirect_to @race
  end

  # Flip start_item.finished to false
  def continue_time
    @start_item = StartItem.find(params[:id])
    @race = Race.find(@start_item.race_id)
    @start_item.finished = false
    @start_item.save
    redirect_to @race
  end

  private

  def start_item_params
    params.require(:start_item).permit(:race_id, :racer_id, :bib)
  end
end