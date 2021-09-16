class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record


  def index
    instructors = Instructor.all
    render json: instructors
  end

  def show
    instructor = find_instructor #find gives you and activerecord error that you can use to find response ..find_by would return nill
    render json: instructor
  end

  def create
    instructor = Instructor.create!(instructor_params)
    render json: instructor, status: :created
  end

  def update
    instructor = find_instructor
    instructor.update!(instructor_params) #! if there's an error it will use the rescue_from at the top to run error message, if no error works normally 
    render json: instructor
  end

  def destroy
    instructor = find_instructor
    instructor.destroy
    head :no_content
  end


  private 

  def render_invalid_record(invalid)
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def render_record_not_found_response
    render json: { error: "Instructor not found" }, status: :not_found
  end

  def find_instructor
    Instructor.find(params[:id])
  end 

  def instructor_params
    params.permit(:name)
  end
end
