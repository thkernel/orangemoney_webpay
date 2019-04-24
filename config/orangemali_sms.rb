# requirements
require "lib/orangemali_sms"

OrangemaliSms.configure do |config|
    config.authorization_header = ENV['orangemali_sms_authorization_header']
end