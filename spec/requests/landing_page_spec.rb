require 'rails_helper'

RSpec.describe "Landing Page", type: :request do
  describe "GET /" do
    it "returns the landing page with correct content" do
      get root_path  # Assuming root_path is the route for landing page
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Welcome to NEO")
      expect(response.body).to match(/linear-gradient/)
    end
  end
end
