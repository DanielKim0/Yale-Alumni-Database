class StudentsController < ApplicationController
  def new
     @student = Student.new
  end

  def show
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.new(student_params)
    @student.name = "#{@student.first_name} #{@student.last_name}"
    if @student.save
      flash[:success] = "Student successfully created!"
      redirect_to @student
    else
      render 'new'
    end
  end

  def index
    respond_to do |format|
      format.html do
        @students = Student.search(params).paginate(page: params[:page], :per_page => 100)
      end
      format.csv do
        @students = Student.all
        send_data @students.to_csv
      end
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    flash[:success] = "Student deleted."
    redirect_to students_url
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(student_params)
      flash[:success] = "Student updated."
      redirect_to @student
    else
      render 'edit'
    end
  end

  def import
    success = Student.import(params[:file])
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
    def student_params
      params.require(:student).permit(:first_name, :last_name, :name, :email, :year)
    end
end
