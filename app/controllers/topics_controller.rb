class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :find_resource

  def new
    @topic = @group.topics.build
  end

  def create
    @topic = @group.topics.build group_topic_params
    @topic.user = current_user
    if @topic.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def show
    @topic = @group.topics.find(params[:id])
    @replies = @topic.replies
    @reply = GroupTopicReply.new
  end

  private
  def find_resource
    @course = Course.find(params[:course_id])
    @group = @course.group
  end

  def group_topic_params
    params.require(:group_topic).permit :body, :title
  end
end
