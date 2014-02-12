class AdminEventsController < ApplicationController
  def index
    @courses = Event.all.page(params[:page]).per(6)
  end
end
