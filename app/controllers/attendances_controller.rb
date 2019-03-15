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
      render 'new'
    else
      render 'new'
    end
  end

  def destroy
    Attendance.find(params[:id]).destroy
    flash[:success] = "Attendance successfully wiped!"
    redirect_back(fallback_location: root_path)
  end

  def import
    success = Attendance.import(params[:file])
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
    def attendance_params
      params.require(:attendance).permit(:alumnus_id, :event_id, :alumnus_email, :event_name)
    end
end
