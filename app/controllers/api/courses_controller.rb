module Api
  class CoursesController < ApplicationController
    def participants
      @course = Course.find(params[:id])
      @users = @course.ordered_users.recent(10)
    end
  end
end
