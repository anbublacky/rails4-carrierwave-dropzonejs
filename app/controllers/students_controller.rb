class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.create
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      add_more_images([student_params[:imagefile]])
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.json { render json: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', status: 400 }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    remove_image_at_index(params["image_index"].to_i)
    @student.save
    respond_to do |format|
      format.json { render :show, status: :ok, location: @student }
    end
  end

  def progress_limit
    @student = Student.find_by_id(params["student_id"])
    respond_to do |format|
      format.js
    end
  end
  private
    def add_more_images(new_images)
      images = @student.imagefile
      images += new_images
      @student.imagefile = images
    end

    def remove_image_at_index(index)
      remain_images = @student.imagefile # copy the array
      deleted_image = remain_images.delete_at(index) # delete the target image
      deleted_image.try(:remove!) # delete image from S3
      @student.imagefile = remain_images # re-assign back
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :age, :imagefile)
    end
end
