require 'spec_helper'

describe UsersController do
  describe 'GET show' do
    let(:login) { 'shinebox' }
    let!(:user) { create(:user, :login => login) }

    it 'finds user by login' do
      get 'show', :id => login
      assigns[:user].should == user
    end
  end
end
