class ZipCodeExtracter
  ZIP_CODE_REGEX = { "IN" => /\b\d{6}\b/ }.freeze

  def self.call(country_code, location)
    regex = ZIP_CODE_REGEX[country_code.upcase]
    location.match(regex).to_s
  end
end
