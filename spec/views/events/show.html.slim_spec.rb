require File.expand_path('../../../spec_helper', __FILE__)

describe 'courses/show.html.slim' do
  let(:course) { create(:course, :markdown) }
  let(:current_user) { build_stubbed(:user) }
  before do
    controller.stub(:current_user) { current_user }
    assign :course, course
    render :template => 'courses/show', :locals => { :current_user => current_user}
  end
  subject { rendered }
  it { should have_content(course.title) }
  it { should include(course.content_html) }
  it { should include(course.location_guide_html) }
end
