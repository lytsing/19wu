class GroupController < ApplicationController
  def course
    group = Group.where(slug: params[:slug]).first!
    @course = group.courses.latest.first
    render 'courses/show'
  end

  def followers
    group = Group.where(slug: params[:slug]).first!
    @course = group.courses.latest.first
    render 'courses/followers'
  end
end
