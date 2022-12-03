module OrangeMoneyWebpay
    class Configuration
        attr_accessor :authorization_header, 
        :remote_url,
        :access_token_url, 
        #:access_token,
        #:pay_token,
        #:notif_token,
        #:payment_url,
        :payment_request,
        :payment_request_url, 
        :merchant_key,
        :currency,
        :return_url,
        :cancel_url,
        :notif_url,
        :lang,
        :reference
       
        
    end
end