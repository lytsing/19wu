module Api
  class EventsController < ApplicationController
    def participants
      @course = Event.find(params[:id])
      @users = @course.ordered_users.recent(10)
    end
  end
end
