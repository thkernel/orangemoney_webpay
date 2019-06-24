module OrangeSmsApi
    class OrangeSmsApiError < StandardError; end
    class OrangeSmsApiNotConfiguredError < OrangeSmsApiError; end
  end