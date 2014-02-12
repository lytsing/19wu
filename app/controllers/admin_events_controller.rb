class AdminEventsController < ApplicationController
  def index
    @events = Event.all.page(params[:page]).per(6)
  end
end
