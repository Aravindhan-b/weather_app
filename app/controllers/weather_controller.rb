class WeatherController < ApplicationController
  before_action :extract_zip_code, only: [ :show ]
  def show
    if @zip_code.present?
      response = WeatherFetcher.call(@zip_code, @country_code)
      if response["error"].present?
        render json: response["error"], status: response[:status]
      else
        render json: response, status: :ok
      end
    else
      render json: "Invalid Zipcode", status: :unprocessable_entity
    end
  end

  private

  def extract_zip_code
    @location = params[:location]
    @country_code = params[:country_code]

    @zip_code = ZipCodeExtracter.call(@country_code, @location)
  end
end
