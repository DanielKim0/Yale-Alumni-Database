class AlumniController < ApplicationController
  def show
    @alumnus = Alumnus.find(alumnus_params)
  end

  def new
    @alumnus = Alumnus.new
  end

  def create
    @alumnus = Alumnus.new(params[:alumnus])
  end

  if @alumnus.save
    # ye
  else
    render 'new'
  end

  private
    def alumnus_params
      params.require(:alumnus).permit(:name, :email, :phone, :location,
        :college, :yale_degree, :yale_degree_year, :other_degrees, :linkedin,
        :employer, :employed_field, :recommender)
    end
end
