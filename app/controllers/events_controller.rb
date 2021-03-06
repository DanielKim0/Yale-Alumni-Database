class EventsController < ApplicationController
  def new
	   @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @attendances = @event.attendances.paginate(page: params[:page], :per_page => 100)
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
    respond_to do |format|
      format.html do
        @events = Event.search(params).paginate(page: params[:page], :per_page => 100)
      end
      format.csv do
        @events = Event.all
        send_data @events.to_csv
      end
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event deleted."
    redirect_to events_url
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
	  flash[:success] = "Event updated."
	  redirect_to @event
    else
      render 'edit'
    end
  end

  def import
    success = Event.import(params[:file])
    if success == 0
      flash[:success] = "File successfully uploaded."
    elsif success == -1
      flash[:danger] = "File unsuccessfully uploaded."
    else
      flash[:warning] = "File uploaded with #{success} #{'failure'.pluralize(success)}."
    end
    redirect_back(fallback_location: root_path)
  end

  private

    def event_params
      params.require(:event).permit(:name, :month, :year, :description,
        :CLY_sponsored, :location)
    end

end
