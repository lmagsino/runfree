# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Health" do
  describe "GET /api/v1/health" do
    it "returns ok status" do
      get "/api/v1/health"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
    end

    it "returns health check data" do
      get "/api/v1/health"

      json = JSON.parse(response.body)

      expect(json["status"]).to eq("ok")
      expect(json["timestamp"]).to be_present
      expect(json["version"]).to eq("1.0.0")
      expect(json["services"]).to be_a(Hash)
    end
  end
end
