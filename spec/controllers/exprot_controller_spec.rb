require 'spec_helper'

describe ExportController do

  describe "GET 'index'" do
    let(:user) { login_user }
    let(:course) { create(:course, user: user) }

    it "renders the export index" do
      get 'index', :course_id => course.id
      response.should render_template('index')
    end
  end

end
