class RacesController < ApplicationController

  @races = Race.includes(:race)

  # Show all races
  def index
    @races = Race.all
    if params[:search]
      @races = Race.search(params[:search])
    end
  end

  # Show race by id
  def show
    @race = Race.find(params[:id])
  end

  # Delete race
  def destroy
    @race = Race.find(params[:id])
    @race.results.destroy_all
    @race.destroy
    update_race_count()

    redirect_to races_path
  end

  # Edit race
  def edit
    @race = Race.find(params[:id])
  end

  # Calculate new race counts
  def update_race_count()
    @racers = Racer.all
    for r in @racers
      race_count = Result.where(racer_id: r.id).count
      r.update_attribute(:race_count, race_count)
    end
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

  #Permit parameters when creating article
  private
  def race_params
    params.require(:race).permit(:date)
  end
end