# requirements
require "lib/orange_sms_api"

OrangeSmsApi.configure do |config|
    config.authorization_header = ENV['orange_sms_api_authorization_header']
end