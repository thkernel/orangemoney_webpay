# Gems
require "faraday"
require "json"

# Files
#require "orange_money_webpay/version"
#require "orange_money_webpay/configuration"
#require "orange_money_webpay/exceptions"
#require "orange_money_webpay/interceptor"
#require "orange_money_webpay/client"

require_relative "orange_money_webpay/version"
require_relative "orange_money_webpay/configuration"
require_relative "orange_money_webpay/exceptions"
require_relative "orange_money_webpay/interceptor"
require_relative "orange_money_webpay/client"

module OrangeMoneyWebpay
  
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

