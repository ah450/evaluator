require 'rails_helper'

RSpec.describe "Errors", type: :request do
  describe "GET /errors" do
    it "works! (now write some real specs)" do
      user = FactoryGirl.create(:teacher)
      expect(User).to receive(:find_by_token).and_raise('Some fancy error')
      get api_users_path, nil, get_token(user.token)
      expect(response).to have_http_status 500
      expect(json_response[:message]).to eql(Rails.application
        .config.configurations[:error_messages][:internal_server_error])
    end
  end
end
