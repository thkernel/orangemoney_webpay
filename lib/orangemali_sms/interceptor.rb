# Requirements.

require "faraday"
require "json"

module OrangeMaliSms
    module HttpInterceptor


        class << self 
            attr_accessor :api_base
        end


        def get_token

            # Inialize a new connection.
            conn = Faraday.new(
                url: OrangeMaliSms.configuration.base_url, 
                ssl: {
                ca_path: "/usr/lib/ssl/certs"}
                )


            # Making a http post request
            response =  conn.post do |req|
                req.url = OrangeMaliSms.configuration.authenticate_endpoint
                req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
                req.headers['Authorization'] = OrangeMaliSms.configuration.authorization
            end

           if response.status == 200
            response_body = response.body
            OrangeMaliSms.configuration.token = response_body.access_token
           end

        end

        def post(endpoint, message)
             

            if OrangeMaliSms.configuration.base_url.present?

                # Inialize a new connection.
                conn = Faraday.new(url: OrangeMaliSms.configuration.base_url) 

                payload = {:outboundSMSMessageRequest => { 
                            :address =>  "tel:+#{message[:recipient_phone_number]}" , 
                            :senderAddress => "tel:+#{OrangeMaliSms.configuration.dev_phone_number}", 
                            :outboundSMSTextMessage => { 
                                :message => message[:body] 
                            } 
                        } 
                    }

                response =  conn.post do |req|
                    req.url = endpoint + "/tel%3A%2B#{OrangeMaliSms.configuration.dev_phone_number}/requests"
                    req.headers['Content-Type'] = 'application/js'
                    req.headers['Authorization'] = 'Bearer ' + OrangeMaliSms.configuration.access_token
                    req.body = payload.to_json
                end
             

                if response.status == 200
                    get_token
                else
                    return response
                end
            else
                render text: "Invalid API Base!"
            end
        end

      

    
    end
end