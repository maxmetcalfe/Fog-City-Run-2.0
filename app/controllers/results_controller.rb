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
    @result.destroy

    redirect_to racers_path
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
      redirect_to Race.find(@result.race_id)
    else
      render 'edit'
    end
  end

  # import JSON
  def import
    Result.import(params)
    #render plain: "Reponse from results import"
    redirect_to root_url, notice: "Results imported successfully"
  end

  # import file
  def upload
    @upload_result_ids = Result.upload(params[:file], params[:date])
    puts "We just uploaded the following results: " + @upload_result_ids.to_s
  end

  def must_be_admin
    unless current_user && current_user.admin?
      redirect_to root_path, notice: "Some message"
    end
  end

  #Permit parameters when creating result
  private
  def result_params
    params.require(:result).permit(:rank, :bib, :racer_id, :group_name, :time, :race_id)
  end
end