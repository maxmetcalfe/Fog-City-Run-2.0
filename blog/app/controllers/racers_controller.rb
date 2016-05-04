class RacersController < ApplicationController

  # Show all racers
  def index
    @racers = Racer.all
  end

  # Show racer by id
  def show
    @racer = Racer.find(params[:id])
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

  # Permit parameters when creating article
  private
  def racer_params
    params.require(:racer).permit(:first_name, :last_name)
  end
end