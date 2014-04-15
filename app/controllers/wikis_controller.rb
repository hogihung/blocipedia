class WikisController < ApplicationController


  def index
    @wikis = Wiki.all
  end

  def new
    @wiki = Wiki.new
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def edit
    #...
  end

  def create
    @wiki = Wiki.new(params.require(:wiki).permit(:titel, :body))
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash[:error] = "There was an error saving this wiki.  Please try again."
      render :new
    end
  end

  def update
    #...
  end

  def destroy
    #...
  end
end
