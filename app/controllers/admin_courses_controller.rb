class AdminCoursesController < ApplicationController
  def index
    @courses = Course.all.page(params[:page]).per(6)
  end
end
