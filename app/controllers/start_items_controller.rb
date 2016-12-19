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

  # Edit race
  def edit
    @race = StartItem.find(params[:id])
  end

  # Create start_item
  def create
  	@start_item = StartItem.new(start_item_params)
    id = StartItem.maximum(:id)
    if id.nil?
      @start_item.id = 1
    else
      @start_item.id = id.next
    end
    @start_item.start_time = DateTime.now
    race = Race.find(@start_item.race_id)
    existing_start_item = StartItem.where(:racer_id => @start_item.racer_id, :race_id => @start_item.race_id)
    puts existing_start_item
    if existing_start_item == 1
      puts "EEEEEEEE"
      to_edit = existing_start_item.first
      to_edit.update(bib: start_item_params[:bib])
      to_edit.save
    elsif existing_start_item.length > 1
      puts "ERROR: We have multiple start items for the same racer for this race."
    else
      if @start_item.save
        redirect_to race
      else
        render 'new'
      end
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
    existing_result = Result.where(:racer_id => @start_item.racer_id, :race_id => @start_item.race_id)
    if existing_result.length == 1
      to_edit = existing_result.first
      to_edit.update(time: finish_time)
      to_edit.save
    elsif existing_result.length > 1
      puts "ERROR: We have multiple results for the same racer for this race."
    else
      @result = Result.create(:rank => 0, :id => Result.maximum(:id).next, :group_name => "ALL", :bib => @start_item.bib, :time => Date.today, :racer_id => @start_item.racer_id, :race_id => @start_item.race_id, :time => finish_time)
      @result.save
    end
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