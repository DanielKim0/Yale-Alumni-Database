class EventsController < ApplicationController
  def new
	   @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @attendances = @event.attendances.paginate(page: params[:page])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
	  flash[:success] = "Event successfully created!"
	  redirect_to @event
    else
      render 'new'
    end
  end

  def index
    @events = Event.paginate(page: params[:page])
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event deleted"
    redirect_to events_url
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
	  flash[:success] = "Event updated"
	  redirect_to @event
    else
      render 'edit'
    end
  end

  def import
    if params[:file]
      Event.import(params[:file])
      flash[:success] = "File succssfully uploaded."
      redirect_back(fallback_location: root_path)
    else
      flash[:failure] = "File unsuccessfully uploaded."
      redirect_back(fallback_location: root_path)
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :month, :year, :description,
        :CLY_sponsored, :location)
    end

end
