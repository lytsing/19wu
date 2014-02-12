class EventChangesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_course!
  set_tab :change
  set_tab :new_change, :sidebar, only: [:new]
  set_tab :changes   , :sidebar, only: [:index]

  def index
    @changes = @course.updates
  end

  def new
    @change = @course.updates.build
  end

  def create
    @change = @course.updates.build(course_change_params)
    if @change.save
      redirect_to course_changes_path(@course)
    else
      render :new
    end
  end

  private

  def course_change_params
    params.require(:course_change).permit :content
  end
end
