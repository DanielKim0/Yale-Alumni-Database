class AttendancesController < ApplicationController
  def new
     @attendance = Attendance.new
  end

  def create
    @event = Event.find(params[:attendance][:event_id])
    @attendance = @event.attendances.build(attendance_params)
    if @attendance.save
      flash[:success] = "Attendance successfully logged!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    Attendance.find(params[:id]).destroy
    flash[:success] = "Attendance successfully wiped!"
    redirect_to root_url
  end

  private
    def attendance_params
      params.require(:attendance).permit(:alumnus_id, :event_id)
    end
end
