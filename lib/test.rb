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

# Payload
payload = Hash.new
payload["merchant_key"] = OrangeMoneyWebpay.configuration.merchant_key
payload["currency"] = OrangeMoneyWebpay.configuration.currency
payload["order_id"] = "SUB-2300"
payload["amount"] = 1250
payload["return_url"] = OrangeMoneyWebpay.configuration.return_url
payload["cancel_url"] = OrangeMoneyWebpay.configuration.cancel_url
payload["notif_url"] = OrangeMoneyWebpay.configuration.notif_url
payload["lang"] = OrangeMoneyWebpay.configuration.lang
payload["reference"] = OrangeMoneyWebpay.configuration.reference

puts "PAYLOAD: #{payload.inspect}"
payment_request = client.payment_request(payload)
puts "PAYMENT REQUEST: #{payment_request.inspect}"
