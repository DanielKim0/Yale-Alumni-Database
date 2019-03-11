class AttendanceController < ApplicationController
  def create
    @event = Event.find(params[:checkin][:event_id])
    @attendance = @event.attendance.build(checkin_params
    if @attendance.save
      flash[:success] = "Attendance successfully logged!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    attendance.find(params[:id]).destroy
    flash[:success] = "Attendance successfully wiped!"
    redirect_to root_url
  end

  private
    def attendance_params
      params.require(:attendance, :alumnus_id, :event_id)
    end
end
