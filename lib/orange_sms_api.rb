require "orange_sms_api/version"
require "orange_sms_api/configuration"
require "orange_sms_api/client"

module OrangeSmsApi
  
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
