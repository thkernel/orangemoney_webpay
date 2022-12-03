require_relative '../lib/orange_money_webpay'

OrangeMoneyWebpay.configure do |config|
    #config.authorization_header = ENV['orange_money_webpay_authorization_header']
    config.merchant_key = "c5cbb630"
    config.authorization_header = "aHFnVFdNbGFqeFNYcmtWbnpYVVpBT3hIaGlxSnVWR246eUtXN3RhYm9xVWJEOFdpMQ=="
    config.access_token_url = "https://api.orange.com/oauth/v3/token"
    config.payment_request_url = "https://api.orange.com/orange-money-webpay/dev/v1/webpayment"
    config.return_url = "http://exemple.com"
    config.cancel_url = "http://exemple.com"
    config.notif_url = "http://exemple.com"

    config.currency = "OUV"
    config.lang = "fr"
    config.reference = "IKATAXI"
end

config = OrangeMoneyWebpay.configuration
client = OrangeMoneyWebpay::Client.new

access_token = client.get_access_token
puts "CONFIG: #{config.inspect}"



order_id = "FAC-#{Time.now.hour}"
amount = 1250


payment_request = client.payment_request(order_id, amount)
puts "PAYMENT REQUEST: #{payment_request.inspect}"
