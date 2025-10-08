require 'rails_helper'

RSpec.describe "WeatherController", type: :request do
  describe "GET /weather" do
    let(:country_code) { "IN" }
    let(:location) { "Chennai 600001" }

    context "when zip code is present and API returns success" do
      before do
        allow(ZipCodeExtracter).to receive(:call).with(country_code, location).and_return("600001")
        allow(WeatherFetcher).to receive(:call).with("600001", country_code).and_return({
          "temp" => 30,
          "status" => "cloudy",
          "temp_min" => "27",
          "temp_max" => "36"
        })
      end

      it "returns 200 OK with weather data" do
        get "/weather", params: { location: location, country_code: country_code }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("temp" => 30,
          "status" => "cloudy",
          "temp_min" => "27",
          "temp_max" => "36")
      end
    end

    context "when WeatherFetcher returns an error" do
      before do
        allow(ZipCodeExtracter).to receive(:call).and_return("600001")
        allow(WeatherFetcher).to receive(:call).and_return({
          "error" => { "message" => "Invalid API key" },
          status: :unauthorized
        })
      end

      it "returns error message with correct status" do
        get "/weather", params: { location: location, country_code: country_code }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("message" => "Invalid API key")
      end
    end

    context "when zip code extraction fails" do
      before do
        allow(ZipCodeExtracter).to receive(:call).and_return(nil)
      end

      it "returns 422 Unprocessable Entity" do
        get "/weather", params: { location: "Unknown place", country_code: "IN" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq("Invalid Zipcode")
      end
    end
  end
end
