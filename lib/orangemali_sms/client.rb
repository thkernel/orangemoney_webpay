#requirements
require "exceptions"
require_relative "interceptor"
require_relative "message"

module OrangemaliSms
    class Client
        include OrangeMaliSms::HttpInterceptor

        def send_sms(recipient_phone_number, body)
            message = {}
            message.recipient_phone_number = recipient_phone_number
            message.body = body

            post(OrangeMaliSms.configuration.send_sms_endpoint, message)
               
        end
    end
end