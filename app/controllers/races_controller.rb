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

  #Permit parameters when creating race
  private

  def race_params
    params.require(:race).permit(:date)
  end
end