class ArticlesController < ApplicationController

  # Show all articles
  def index
    @articles = Article.all
  end

  # Show article by id
  def show
    @article = Article.find(params[:id])
  end

 def destroy
  @article = Article.find(params[:id])
  @article.destroy
 
  redirect_to articles_path
 end

  def new
  	@article = Article.new
  end

  def edit
  @article = Article.find(params[:id])
 end
 
  # Create article
  def create
    @article = Article.new(article_params)
 
    if @article.save
      redirect_to @article
    else
      render 'new'
  end
   end

  def update
  @article = Article.find(params[:id])
 
  if @article.update(article_params)
    redirect_to @article
  else
    render 'edit'
  end
end

  # Permit parameters when creating article
  private
   def article_params
    params.require(:article).permit(:title, :text)
   end
end