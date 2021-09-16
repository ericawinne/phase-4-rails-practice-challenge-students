class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

  def index
    students = Student.all
    render json: students 
  end

  def show 
    student = find_student
    render json: student 
  end

  def create
    student = Student.create!(student_params)
    render json: student, status: :created
  end

  def update
    student = find_student
    student.update!(student_params) #! if there's an error it will use the rescue_from at the top to run error message, if no error works normally 
    render json: student
  end

  def destroy 
    student = find_student
    student.destroy
    head :no_content
  end


private 

  def render_invalid_record(invalid)
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def render_record_not_found_response
    render json: { error: "Student not found" }, status: :not_found
  end

  def find_student
    Student.find(params[:id])
  end

  def student_params
    params.permit(:name, :age, :major, :instructor_id)
  end

end


