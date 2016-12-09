class StartItemsController < ApplicationController

  # Show all start_items
  def index
    puts params
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
  end

  # Edit race
  def edit
    @race = StartItem.find(params[:id])
  end

  # Create race
  def create
    puts start_item_params
  	@start_item = StartItem.new(start_item_params)
    puts "Creating new"
    if @start_item.save
      redirect_to @start_item
    else
      render 'new'
    end
  end

  # New start_item
  def new
  	@start_item = Race.new
  end

  # Update race
  def update
    @start_item = Race.find(params[:id])
    if @start_item.update(start_item_params)
      redirect_to @start_item
    else
      render 'edit'
    end
  end

  private

  def start_item_params
    params.require(:start_item).permit(:race_id)
  end
end