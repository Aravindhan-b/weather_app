module Weather
  class BaseService
    attr_reader :zip_code, :country_code

    def initialize(zip_code, country_code)
      @zip_code = zip_code
      @country_code = country_code
    end

    def call
      raise "NotImplementedError"
    end
  end
end
