

module OrangeMoneyWebpay
    class Client
        include OrangeMoneyWebpay::HttpInterceptor
        attr_accessor :access_token, :pay_token,:notif_token,:payment_url

        def payment_request(order_id, amount)

            # Payload
            payload = Hash.new
            payload["merchant_key"] = OrangeMoneyWebpay.configuration.merchant_key
            payload["currency"] = OrangeMoneyWebpay.configuration.currency
            payload["order_id"] = order_id
            payload["amount"] = amount
            payload["return_url"] = OrangeMoneyWebpay.configuration.return_url
            payload["cancel_url"] = OrangeMoneyWebpay.configuration.cancel_url
            payload["notif_url"] = OrangeMoneyWebpay.configuration.notif_url
            payload["lang"] = OrangeMoneyWebpay.configuration.lang
            payload["reference"] = OrangeMoneyWebpay.configuration.reference


                        
            # Inialize a new connection.
            request = Faraday.new(OrangeMoneyWebpay.configuration.remote_url, 
                ssl: {
                ca_path: "/usr/lib/ssl/certs"}
            )

            # Making a http post request
            response =  request.post do |req|
                req.url  OrangeMoneyWebpay.configuration.payment_request_url
                
                # Request header
                req.headers['Authorization'] = "Bearer #{self.access_token}"
                req.headers['Content-Type'] = 'application/json'
                req.headers['Accept'] = 'application/json'
                
                # Request body
                req.body = payload.to_json
            end

            if response.status == 201

                response_body = JSON.parse(response.body)

                #OrangeMoneyWebpay.configuration.payment_url = response_body["payment_url"]
                #OrangeMoneyWebpay.configuration.pay_token = response_body["pay_token"]
                #OrangeMoneyWebpay.configuration.notif_token = response_body["notif_token"]

                self.payment_url = response_body["payment_url"]
                self.pay_token = response_body["pay_token"]
                self.notif_token = response_body["notif_token"]
                

                
                return response_body

            elsif response.status == 401

                puts "RESPONSE BODY: #{response_body}"
   
            else
               puts "ERROR: #{response.inspect}"
                puts "API configuration error"
            end
        end

        def get_access_token
            puts "START GETTING ACCESS TOKEN"

            
            # Inialize a new connection.
            request = Faraday.new(OrangeMoneyWebpay.configuration.remote_url, 
                ssl: {
                ca_path: "/usr/lib/ssl/certs"}
            )

            # Making a http post request
            response =  request.post do |req|
                req.url  OrangeMoneyWebpay.configuration.access_token_url
                req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
                req.headers['Authorization'] = "Basic #{OrangeMoneyWebpay.configuration.authorization_header}"
                req.body = "grant_type=client_credentials"
            end

            if response.status == 200

                response_body = JSON.parse(response.body)

                #OrangeMoneyWebpay.configuration.access_token = response_body["access_token"]
                self.access_token = response_body["access_token"]
                puts "LE TOKEN: #{self.access_token}"

            elsif response.status == 401

                puts "RESPONSE BODY: #{response_body}"
                  
            else
                puts "API configuration error"
            end
        end
        
    end
end