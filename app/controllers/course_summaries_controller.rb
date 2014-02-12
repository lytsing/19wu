class CourseSummariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_course!
  set_tab :course_summary, only: :new

  def new
    @summary = @course.course_summary || @course.build_course_summary
    render :new
  end

  def create
    @summary = @course.build_course_summary(course_summary_params)

    if @summary.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def update
    @summary = @course.course_summary

    if @summary.update_attributes(course_summary_params)
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  private

  def course_summary_params
    params.require(:course_summary).permit :content
  end
end
