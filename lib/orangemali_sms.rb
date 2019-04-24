require "orangemali_sms/version"
require "orangemali_sms/configuration"

module OrangemaliSms
  
  class << self
      attr_accessor :configuration
  end

  def self.configuration
      @configuration ||= Configuration.new
  end

  def self.configure
      yield(configuration)
  end
end
