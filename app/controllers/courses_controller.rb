class CoursesController < ApplicationController
  include CourseHelper
  before_filter :authenticate_user!, except: [:show,:followers]
  load_and_authorize_resource only: [:edit, :update]
  set_tab :edit, only: :edit

  def index
    @courses = current_user.courses.latest
  end

  def ordered
    @courses = current_user.ordered_courses.latest.uniq
  end

  def show
    @course = Course.find(params[:id])
    @user = User.friendly.find(@course.user_id)
    @profile = @user.profile
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  def new
    find_source_courses
    @course = if params[:from]
               Course.find(params[:from]).dup
             else
               current_user.courses.new
             end
  end

  def create
    @course = current_user.courses.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_tickets_path(@course), notice: I18n.t('flash.courses.created') }
        format.json { render json: @course, status: :created, location: @course }
      else
        find_source_courses
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @course.update_attributes(course_params)
        format.html { redirect_to edit_course_path(@course), notice: I18n.t('flash.courses.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def follow
    group = Course.find(params[:id]).group
    current_user.follow group
    render json: { count: group.followers_count }
  end
  def unfollow
    group = Course.find(params[:id]).group
    current_user.stop_following group
    render json: { count: group.followers_count }
  end

  def followers
    @course = Course.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @course }
    end
  end

  private
  def course_params
    params.require(:course).permit(
      :content, :location, :location_guide, :start_time, :end_time, :title, :slug, :picture,:abstract,:contact, :telephone,
      compound_start_time_attributes: [:date, :time], compound_end_time_attributes: [:date, :time]
      )
  end
  # TODO: move these to a model using ActiveModel validation

  def find_source_courses
    group_ids = (current_user.group_ids + GroupCollaborator.where(user_id: current_user.id).map(&:group_id)).uniq
    @source_courses = Course.where(group_id: group_ids).latest.limit(1)
  end
end
