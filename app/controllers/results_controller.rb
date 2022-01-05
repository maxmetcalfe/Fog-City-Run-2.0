class ResultsController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_filter :must_be_admin, only: [:edit]

  def index
  end

  # Show result
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

    redirect_to Race.find(@race_id)
  end

  # Edit result
  def edit
    @result = Result.find(params[:id])
  end

  def create
    @result = Result.new(result_params)
    @result.id = Result.maximum(:id).next
    @result.rank = 0

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

  # Permit parameters when creating result
  private
  def result_params
    params.require(:result).permit(:rank, :bib, :racer_id, :group_name, :time, :race_id)
  end
end