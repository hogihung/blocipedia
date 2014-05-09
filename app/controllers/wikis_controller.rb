class WikisController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    if !current_user
      @wikis = Wiki.where(private: false)
    elsif current_user && current_user.role == "admin"
      @wikis = Wiki.all
    else
      @wikis = Wiki.where("user_id = ? OR private = ?", current_user.id, false)
    end
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def show
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki

    @users = User.potential_collaborators(@wiki.user) if current_user
  end

  def edit
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    authorize @wiki
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash[:error] = "There was an error saving this wiki.  Please try again."
      render :new
    end
  end

  def update
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki updated."
      redirect_to @wiki
    else
      flash[:error] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki
    if @wiki.destroy
      flash[:notice] = "Wiki was deleted successfully."
      redirect_to @wiki
    else
      flash[:error] = "There was an error deleting the wiki."
      render :show
    end
  end

  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private, :user_id, user_ids:[])
  end

end
