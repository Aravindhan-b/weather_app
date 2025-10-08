module Weather
  class OpenWeatherMapService < BaseService
    # sample_url = 'https://api.openweathermap.org/data/2.5/weather?zip=94040,us&appid=446c517----bab4e'

    API_KEY = ENV.fetch("OPEN_WEATHER_MAP_KEY")
    BASE_URL = "https://api.openweathermap.org/data/2.5/weather"
    def call
      response = Faraday.get(BASE_URL, {
        zip: "#{zip_code},#{country_code.upcase}",
        appid: API_KEY
      })

      if response.success?
        parse_response(response)
      else
        { error: JSON.parse(response.body),
          status: response.status }
      end
    end

    private

    def parse_response(response)
      response_body = JSON.parse(response.body)
      main = response_body["main"]
      {
        status: response_body.dig("weather", 0, "main"),
        temp: main["temp"],
        temp_min: main["temp_min"],
        temp_max: main["temp_max"]
      }
    end
  end
end
