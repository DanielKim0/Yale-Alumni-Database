class AlumniController < ApplicationController
  def new
	   @alumnus = Alumnus.new
  end

  def show
    @alumnus = Alumnus.find(params[:id])
  end

  def create
    @alumnus = alumnus.new(alumnus_params)
    if @alumnus.save
	  flash[:success] = "alumnus successfully created!"
	  redirect_to @alumnus
    else
      render 'new'
    end
  end

  def index
    @alumni = alumnus.paginate(page: params[:page])
  end

  def destroy
    alumnus.find(params[:id]).destroy
    flash[:success] = "alumnus deleted"
    redirect_to alumni_url
  end

  def edit
    @alumnus = alumnus.find(params[:id])
  end

  def update
    @alumnus = alumnus.find(params[:id])
    if @alumnus.update_attributes(alumnus_params)
	  flash[:success] = "alumnus updated"
	  redirect_to @alumnus
    else
      render 'edit'
    end
  end

  private
    def alumnus_params
      params.require(:alumnus).permit(:name, :email, :phone, :location,
        :college, :yale_degree, :yale_degree_year, :other_degrees, :linkedin,
        :employer, :employed_field, :recommender)
    end
end
