require 'spec_helper'

describe CollaboratorsController do
  let(:user) { login_user }
  let(:partner) { create(:user) }
  let(:course) { create(:course, user: user) }
  let(:collaborator) { create(:group_collaborator, user_id: partner.id, group_id: course.group.id) }

  describe "GET 'index'" do
    before { collaborator }
    it "renders the participant list" do
      get :index, course_id: course.id
      assigns[:collaborators].first[:id].should eql collaborator.id
    end
  end
  describe "POST 'create'" do
    it 'creates the collaborator' do
      expect {
        post :create, course_id: course.id, login: partner.login
      }.to change{GroupCollaborator.count}.by(1)
    end
  end
  describe "DELETE 'destroy'" do
    before { collaborator }
    it 'destroy the collaborator' do
      expect {
        delete :destroy, course_id: course.id, id: collaborator.id
      }.to change{GroupCollaborator.count}.by(-1)
    end
  end
end
