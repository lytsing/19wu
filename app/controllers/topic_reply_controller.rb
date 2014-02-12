class TopicReplyController < ApplicationController
  before_filter :authenticate_user!

  def create
    @course = Course.find(params[:course_id])
    @topic = @course.group.topics.find(params[:topic_id])
    @reply = @topic.replies.build topic_reply_params
    @reply.user = current_user
    @reply.save
    redirect_to course_topic_path(@course, @topic)
  end

  private

  def topic_reply_params
    params.require(:group_topic_reply).permit :body
  end
end
