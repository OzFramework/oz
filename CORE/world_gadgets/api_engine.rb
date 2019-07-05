require_relative '../../utils/oz_loader'
OzLoader.check_gems(%w[httpi], 'APIEngine')
require 'httpi'
require 'json'

module ApiEngine
  class Rest

    def self.world_name
      :api_engine
    end

    def initialize(world = nil)
      ensure_installed('HTTPI')
      @world = world
      @request = HTTPI::Request.new
    end

    ###############REQUEST SECTION#############
    def request(endpoint = nil, type, *args)
      fail 'must provide an endpoint' if endpoint.nil?
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
      user = args[:username] if args[:username].nil?
      pass = args[:password] if args[:password].nil?
      domain = args[:domain] if args[:domain].nil?

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
      Dir.glob('*/*').grep(/#{@env}/)[0]
    end

    ################RESPONSE SECTION###################
    def body_hash
      fail "Must have a proper request to return the body" if @response.nil?
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
      @response.error?
    end

  end

end

#test calls and validation checks
# call = ApiEngine::Rest.new
# call.request('https://revenueenterpriseservices.int.igsenergy.net/BillingAccount/GetInformation', :post, body: '{"InvoiceGroupID" : 4899259}') #post example
# call.request('https://revenueenterpriseservices.int.igsenergy.net/Invoices/ExcelSummarySheetData/22644713', :get, :auth_type => 'ssl', :env => 'int') #get example
# fail 'Response length must be greater than 0' unless call.body_hash['FileData'].length > 0 #get example validation
# fail "Call failed with #{call.response.code} response code" unless !call.error?
