class ResultsController < ApplicationController

  @results = Result.includes(:racer)
  @results = Result.includes(:race)

  skip_before_action :verify_authenticity_token, only: [:import]
  before_filter :must_be_admin, only: [:edit, :import, :upload]

  # Show all results
  def index
    @results = Result.all
  end

  # Show result by id
  def show
    @result = Result.find(params[:id])
  end

  # Delete result
  def destroy
    @result = Result.find(params[:id])
    @race_id = @result.race_id
    @result.destroy
    validate_ranks(@result.race_id)

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
    @result = Result.upload(params[:file], params[:date])
    if @result == "FAILURE_DATE"
      flash.now[:danger] = "Invalid Date"
    elsif @result == "FAILURE_FILE"
      flash.now[:danger] = "Ooops. You forgot a file!"
    elsif @result.any?
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

  # Sort and save the ranks for a particular race
  def validate_ranks(race_id)
     @results = Result.where(:race_id => race_id)
     @sorted = @results.sort_by {|result| result.time}
     for r in @sorted
       r.rank = @sorted.index(r) + 1
       r.save!
     end
  end

  #Permit parameters when creating result
  private
  def result_params
    params.require(:result).permit(:rank, :bib, :racer_id, :group_name, :time, :race_id)
  end
end