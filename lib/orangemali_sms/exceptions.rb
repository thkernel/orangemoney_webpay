module OrangemaliSms
    class OrangemaliSmsError < StandardError; end
    class OrangemaliSmsNotConfiguredError < OrangemaliSmsError; end
    class OrangemaliSmsError < OrangemaliSmsError; end
  end