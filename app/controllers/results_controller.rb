class ResultsController < ApplicationController

  @results = Result.includes(:racer)
  @results = Result.includes(:race)

  skip_before_action :verify_authenticity_token, only: [:import]
  before_filter :must_be_admin, only: [:edit, :import, :upload]

  # Show all results
  def index
    @results = Result.all
    # Refresh all counts
    update_race_count()
    update_streak_calendar([@results.pluck(:racer_id)])
  end

  # Show result by id
  def show
    @result = Result.find(params[:id])
  end

  # Delete result
  def destroy
    @result = Result.find(params[:id])
    @race_id = @result.race_id
    racer_id = @result.racer_id
    @result.destroy
    validate_ranks(@result.race_id)
    update_streak_calendar([racer_id])

    redirect_to Race.find(@race_id)
  end

  # Edit result
  def edit
    @result = Result.find(params[:id])
  end

  def create
  	@result = Result.new(result_params)
    @result.rank = 0
    @result.id = Result.maximum(:id).next
    update_race_count()
    update_streak_calendar([@result.racer_id])

    if @result.save
      validate_ranks(@result.race_id)
      redirect_to Race.find(@result.race_id)
    else
      render 'new'
    end
  end

  # New result
  def new
    @result = Result.new
  end

  # Update result
  def update
    @result = Result.find(params[:id])
    if @result.update(result_params)
      validate_ranks(@result.race_id)
      update_race_count()
      update_streak_calendar([@result.racer_id])

      redirect_to Race.find(@result.race_id)
    else
      render 'edit'
    end
  end

  # import JSON
  def import
    Result.import(params)
    redirect_to root_url, notice: "Results imported successfully"
  end

  # import file
  def upload
    @status = Result.upload(params[:file], params[:date])
    if @status == "FAILURE_DATE"
      flash.now[:danger] = "Invalid Date"
    elsif @status == "FAILURE_FILE"
      flash.now[:danger] = "Ooops. You forgot a file!"
    elsif @status.any?
      update_race_count()
      update_streak_calendar([@status])
      flash.now[:success] = "Success"
    end
    puts "We just uploaded the following results: " + @result.to_s
  end

  # Basic admin permissions
  def must_be_admin
    unless current_user && current_user.admin?
      redirect_to root_path
    end
  end

  #Permit parameters when creating result
  private
  def result_params
    params.require(:result).permit(:rank, :bib, :racer_id, :group_name, :time, :race_id)
  end
end