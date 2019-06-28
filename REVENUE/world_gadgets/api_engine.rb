require 'httpi'
require 'json'

module ApiEngine
  class Rest

    def initialize
      @request = HTTPI::Request.new
    end

    ###############REQUEST SECTION#############
    def request(endpoint, type, *args)
      fail 'must provide an endpoint' unless !endpoint.nil?
      #type can be put, post, get, delete, or head
      fail 'type should be a symbol' unless type.is_a?(Symbol)

      payload_info(endpoint, args)
      @@response = HTTPI.request(type, @request, adapter = @adapter)
    end

    def payload_info(endpoint, args)
      unless args.empty?
        args = args[0]
        authenticate(args[:auth_type], args) unless args[:auth_type].nil?
        @adapter = args[:adapter] unless args[:adapter].nil?
        @request.body = args[:body] unless args[:body].nil?
        @request.headers = args[:headers] unless args[:headers].nil?
        @request.query = args[:query] unless args[:query].nil?
      end
      #This is used to bypass ssl certs
      @request.auth.ssl.verify_mode = :none
      #TODO get ssl cert file working
      #@request.auth.ssl.ca_cert_file = 'certificate.pem'
      @request.url = endpoint
    end

    def authenticate(type, *args)
      user = args[:username]
      pass = args[:password]
      domain = args[:domain]

      case type
      when 'basic'
        request.auth.basic(user, pass)
      when 'ntlm'
        @request.auth.ntlm(user, pass, domain)
      when 'ssl'
        "ssl cert selected"
      when 'digest'
        request.auth.digest(user, pass)
      else
        "some other auth"
      end
    end

    ################RESPONSE SECTION####################
    def hash_body
      fail "Must have a proper request to return the #{__method__}" unless @response.nil?
      JSON.parse(@@response.body)
    end

    ############VALIDATION SECTION#############
    def success_code?
      @@response.code.between?(200, 299)
    end

  end

  class Soap
    #stub for soap services if ever needed
  end
end

call = ApiEngine::Rest.new
# response = call.request('https://revenueenterpriseservices.int.igsenergy.net/BillingAccount/GetInformation', :post, body: '{"InvoiceGroupID" : 4899259}') #post example
response = call.request('https://revenueenterpriseservices.int.igsenergy.net/Invoices/ExcelSummarySheetData/22644713', :get) #get example
fail 'Response length must be greater than 0' unless call.hash_body['FileData'].length > 0 #get example validation
fail "Call failed with #{call.code} response code" unless call.success_code?