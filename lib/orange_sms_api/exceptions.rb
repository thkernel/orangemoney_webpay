module OrangeSmsApi
    class OrangeSmsApiError < StandardError; end
    class OrangeSmsApiNotConfiguredError < OrangeSmsApiError; end
    class OrangeSmsApiError < OrangeSmsApiError; end
  end