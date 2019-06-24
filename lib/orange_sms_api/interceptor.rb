
module OrangeSmsApi
    module HttpInterceptor


        class << self 
            attr_accessor :api_base
        end


        def get_token

            # Inialize a new connection.
            conn = Faraday.new(OrangeSmsApi.configuration.base_url, 
                ssl: {
                ca_path: "/usr/lib/ssl/certs"}
                )


            # Making a http post request
            response =  conn.post do |req|
                req.url  OrangeSmsApi.configuration.authentication_endpoint
                req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
                req.headers['Authorization'] = OrangeSmsApi.configuration.authorization_header
                req.body = "grant_type=client_credentials"
            end

           if response.status == 200

            response_body = JSON.parse(response.body)
            #puts "RESPONSE BODY: #{response_body}"
            puts "BODY PARSING: #{response_body}"

            OrangeSmsApi.configuration.access_token = response_body[:access_token]
                
            puts "LE TOKEN: #{OrangeSmsApi.configuration.access_token}"
           else
            puts "RESPONSE STATUT: #{response.status}"

            puts "RESPONSE BODY: #{response_body}"
           end

        end

        def post(endpoint, message)
             

            if OrangeSmsApi.configuration.base_url.present?

                # Inialize a new connection.
                conn = Faraday.new(OrangeSmsApi.configuration.base_url) 

                payload = {:outboundSMSMessageRequest => { 
                            :address =>  "tel:+#{message[:recipient_phone_number]}" , 
                            :senderAddress => "tel:+#{OrangeSmsApi.configuration.dev_phone_number}", 
                            :outboundSMSTextMessage => { 
                                :message => message[:body] 
                            } 
                        } 
                    }

                response =  conn.post do |req|
                    req.url  endpoint + "/tel%3A%2B#{OrangeSmsApi.configuration.dev_phone_number}/requests"
                    req.headers['Content-Type'] = 'application/json'
                    req.headers['Authorization'] = 'Bearer ' + OrangeSmsApi.configuration.access_token
                    req.body = payload.to_json
                end
             

                if response.status == 200
                    puts "LE STATUE DE LA REQUETTE EST: #{response.status}"
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                   
                    return response
                else
                    puts "LE STATUT DE LA REQUETTE EST: #{response.status}"
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                    get_token
                end
            else
                render text: "Invalid API Base!"
            end
        end

      

    
    end
end