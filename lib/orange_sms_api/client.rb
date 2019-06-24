

module OrangeSmsApi
    class Client
        include OrangeSmsApi::HttpInterceptor

        def send_sms(recipient_phone_number, body)
            message = {}
            message[:recipient_phone_number] = recipient_phone_number
            message[:body] = body

            puts "MESSAGE: #{message}"
            post(OrangeSmsApi.configuration.send_sms_endpoint, message)
               
        end
    end
end