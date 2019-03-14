class AttendancesController < ApplicationController
  def new
     @attendance = Attendance.new
  end

  def create
    alumnus = Alumnus.find_by(email: attendance_params["alumnus_email"])
    event = Event.find_by(name: attendance_params["event_name"])
    if !(params.has_key? :description)
      params[:description] = ""
    end

    @attendance = Attendance.create({:alumnus => alumnus, :event => event, :description => params[:description]})
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

  def import
    success = Attendance.import(params[:file])
    if success
      flash[:success] = "File successfully uploaded."
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
