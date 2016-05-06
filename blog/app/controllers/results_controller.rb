class ResultsController < ApplicationController

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

  #Permit parameters when creating article
  private
  def result_params
    params.require(:result).permit(:rank, :bib, :racer_id, :group, :time, :date)
  end
end