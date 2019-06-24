
module OrangeSmsApi
    module HttpInterceptor


        class << self 
            attr_accessor :api_base
        end


        def get_token

            # Inialize a new connection.
            conn = Faraday.new(
                url: OrangeSmsApi.configuration.base_url, 
                ssl: {
                ca_path: "/usr/lib/ssl/certs"}
                )


            # Making a http post request
            response =  conn.post do |req|
                req.url = OrangeSmsApi.configuration.authenticate_endpoint
                req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
                req.headers['Authorization'] = OrangeSmsApi.configuration.authorization
            end

           if response.status == 200
            response_body = response.body
            OrangeSmsApi.configuration.access_token = response_body.access_token
           end

        end

        def post(endpoint, message)
             

            if OrangeSmsApi.configuration.base_url.present?

                # Inialize a new connection.
                conn = Faraday.new(url: OrangeSmsApi.configuration.base_url) 

                payload = {:outboundSMSMessageRequest => { 
                            :address =>  "tel:+#{message[:recipient_phone_number]}" , 
                            :senderAddress => "tel:+#{OrangeSmsApi.configuration.dev_phone_number}", 
                            :outboundSMSTextMessage => { 
                                :message => message[:body] 
                            } 
                        } 
                    }

                response =  conn.post do |req|
                    req.url = endpoint + "/tel%3A%2B#{OrangeSmsApi.configuration.dev_phone_number}/requests"
                    req.headers['Content-Type'] = 'application/js'
                    req.headers['Authorization'] = 'Bearer ' + OrangeSmsApi.configuration.access_token
                    req.body = payload.to_json
                end
             

                if response.status == 200
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.status}"
                   
                    return response
                else
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.status}"
                    get_token
                end
            else
                render text: "Invalid API Base!"
            end
        end

      

    
    end
end