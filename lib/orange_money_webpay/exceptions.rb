module OrangeMoneyWebpay
    class OrangeMoneyWebpayError < StandardError; end
    class OrangeMoneyWebpayNotConfiguredError < OrangeMoneyWebpayError; end
  end