class AttendancesController < ApplicationController
  def new
     @attendance = Attendance.new
  end

  def create
    alumnus = Alumnus.find_by(email: params[:attendance][:alumnus_email])
    event = Event.find_by(name: params[:attendance][:event_name])
    if Attendance.create({alumnus_id: alumnus[:id], event_id: event[:id],
      alumnus: alumnus, event: event, description: params[:attendance][:description]})
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

  def import
    if params[:file]
      Attendance.import(params[:file])
      flash[:success] = "File succssfully uploaded."
      redirect_back(fallback_location: root_path)
    else
      flash[:failure] = "File unsuccessfully uploaded."
      redirect_back(fallback_location: root_path)
    end
  end


  private
    def attendance_params
      params.require(:attendance).permit(:alumnus_id, :event_id, :alumnus_email, :event_name)
    end
end
