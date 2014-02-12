class EventTicketsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_course!
  set_tab :ticket

  def index
    @tickets = @course.tickets
  end

  def new
    @ticket = @course.tickets.build
  end

  def create
    @ticket = @course.tickets.build(course_ticket_params)
    if @ticket.save
      redirect_to course_tickets_path(@course)
    else
      render :new
    end
  end

  def edit
    @ticket = @course.tickets.find(params[:id])
  end

  def update
    @ticket = @course.tickets.find(params[:id])
    if @ticket.update_attributes(course_ticket_params)
      redirect_to course_tickets_path(@course), notice: I18n.t('flash.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @ticket = @course.tickets.find(params[:id])
    @ticket.destroy
    redirect_to course_tickets_path(@course), notice: I18n.t('flash.destroyed')
  end

  private

  def course_ticket_params
    params.require(:course_ticket).permit :name, :price, :require_invoice, :description, :tickets_quantity
  end
end
