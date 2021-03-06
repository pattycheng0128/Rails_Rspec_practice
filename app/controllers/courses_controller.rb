class CoursesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @courses = Course.includes(:user)
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    # @course = Course.new(course_params)
    # @course.user = current_user #for rspec test
    @course = current_user.courses.build(course_params)
    if @course.save
      redirect_to courses_path
    else
      render :new
    end
  end

  def edit
    # @course = Course.find(params[:id])
    @course = current_user.courses.find(params[:id])
  end

  def update
    # @course = Course.find(params[:id])
    @course = current_user.courses.find(params[:id])
    if @course.update(course_params)
      redirect_to courses_path
    else
      render :edit
    end
  end

  def destroy
    # @course = Course.find(params[:id])
    @course = current_user.courses.find(params[:id])
    @course.destroy
    redirect_to courses_path
  end
  
  private
  def course_params
    params.require(:course).permit(:title, :description)
  end
end
