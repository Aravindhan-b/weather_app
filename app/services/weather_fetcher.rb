class WeatherFetcher
  PROVIDER = {
    open_weather_map: Weather::OpenWeatherMapService
  }

  def self.call(zip_code, country_code, provider: :open_weather_map)
    service_class = PROVIDER[provider]
    raise ArgumentError, "Not a provider" if service_class.nil?

    service_obj = service_class.new(zip_code, country_code)
    service_obj.call
  end
end
