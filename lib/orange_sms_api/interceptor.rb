
module OrangeSmsApi
    module HttpInterceptor



        def api_configured?
            base_url = OrangeSmsApi.configuration.base_url
            authorization_header = OrangeSmsApi.configuration.authorization_header
            authentication_endpoint = OrangeSmsApi.configuration.authentication_endpoint

            if base_url.present? && authorization_header.present? && authentication_endpoint.present?
                return true
            else
                return false 
            end
        end

        def access_token_validity?
            access_token_date = OrangeSmsApi.configuration.access_token_date if OrangeSmsApi.configuration.access_token_date
            current_date = Date.today
            if access_token_date.present? && (current_date - access_token_date) <= 90
                
                return true
            else
                return false

            end
        end

        def get_token
            if api_configured?
                unless access_token_validity?
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

                        OrangeSmsApi.configuration.access_token = response_body["access_token"]
                        OrangeSmsApi.configuration.access_token_date = Date.today
                    
                        puts "LE TOKEN: #{OrangeSmsApi.configuration.access_token}"
                        puts "TOKEN DATE: #{OrangeSmsApi.configuration.access_token_date}"

                    elsif response.status == 401

                        puts "RESPONSE BODY: #{response_body}"
                    end

                end
            else
                puts "API configuration error"
            end
        end


        

        def post(endpoint, message)
             

            if api_configured? 
                
                get_token
                
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
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                   
                    return response
                elsif response.status == 401
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                    #get_token
                end
            else
                render text: "Invalid API Base!"
            end
        end

      

    
    end
end