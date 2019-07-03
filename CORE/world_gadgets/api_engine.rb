ensure_installed('HTTPI')
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
      @response = HTTPI.request(type, @request, adapter = @adapter)
    end

    def payload_info(endpoint, args)
      unless args.empty?
        args = args[0]
        @env = args[:env]
        @adapter = args[:adapter] unless args[:adapter].nil?
        @request.body = args[:body] unless args[:body].nil?
        @request.headers = args[:headers] unless args[:headers].nil?
        @request.query = args[:query] unless args[:query].nil?
        authenticate(args[:auth_type], args) unless args[:auth_type].nil?
      end

      @request.url = endpoint
    end

    def authenticate(type, args)
      user = args[:username] unless !args[:username].nil?
      pass = args[:password] unless !args[:password].nil?
      domain = args[:domain] unless !args[:domain].nil?

      case type
      when 'basic'
        request.auth.basic(user, pass)
      when 'ntlm'
        @request.auth.ntlm(user, pass, domain)
      when 'ssl'
        @request.auth.ssl.cert_type = :pem
        cert_file = get_cert
        @request.auth.ssl.ca_cert_file = __dir__ + "/#{cert_file}"
      when 'digest'
        request.auth.digest(user, pass)
      else
        #use no verification if nothing is given
        @request.auth.ssl.verify_mode = :none
      end
    end

    def get_cert
      cert = Dir.glob('*/*').grep(/#{@env}/)[0]
      fail 'Unable to locate proper cert' unless !cert.nil?
    end

    ################RESPONSE SECTION###################
    def body_hash
      fail "Must have a proper request to return the body" unless !@response.nil?
      JSON.parse(@response.body)
    end

    def response
      #return full response exactly as it came back from the resource
      @response
    end

    def code
      @response.code
    end

    def body
      @response.body
    end

    ############VALIDATION SECTION#############
    def error?
      @@response.error?
      #this needs to be updated to include all success response codes
      # '*' turns number range into an array
      # success_codes = *(200..299)
      # success_codes.include? @response.code
    end

  end

  class Soap
    #stub for soap services if ever needed
  end
end

#test calls and validation checks
call = ApiEngine::Rest.new
# call.request('https://revenueenterpriseservices.int.igsenergy.net/BillingAccount/GetInformation', :post, body: '{"InvoiceGroupID" : 4899259}') #post example
call.request('https://revenueenterpriseservices.int.igsenergy.net/Invoices/ExcelSummarySheetData/22644713', :get, :auth_type => 'ssl', :env => 'int') #get example
fail 'Response length must be greater than 0' unless call.body_hash['FileData'].length > 0 #get example validation
fail "Call failed with #{call.response.code} response code" unless !call.error?
