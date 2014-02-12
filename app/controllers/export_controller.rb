class ExportController < ApplicationController
  prepend_before_filter :authenticate_user!
  set_tab :export

  def index
    @course = Event.find(params[:course_id])
  end
end
