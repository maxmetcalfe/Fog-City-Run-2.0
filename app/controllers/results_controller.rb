class ResultsController < ApplicationController

  @results = Result.includes(:racer)
  @results = Result.includes(:race)

  skip_before_action :verify_authenticity_token, only: [:import]

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
    @result.destroy

    redirect_to results_path
  end

  # Edit result
  def edit
    @result = Result.find(params[:id])
  end

  # Create article
  def create
  	@result = Result.new(result_params)
    if @result.save
      redirect_to @result
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
      redirect_to @result
    else
      render 'edit'
    end
  end

  # import CSV
  def import
    Result.import(params[:file])
    redirect_to root_url, notice: "Results imported successfully"
  end

  #Permit parameters when creating result
  private
  def result_params
    params.require(:result).permit(:rank, :bib, :racer_id, :group, :time, :race_id)
  end
end