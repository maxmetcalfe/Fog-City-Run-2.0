class RacersController < ApplicationController

  # Show all articles
  def index
    @racers = Racer.all
  end

  # Show article by id
  def show
    @racer = Racer.find(params[:id])
  end

 def destroy
  @racer = Racer.find(params[:id])
  @racer.destroy

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

  def new
  	@racer = Racer.new
  end
end

# Permit parameters when creating article
private
def racer_params
params.require(:racer).permit(:first_name, :last_name)
end


