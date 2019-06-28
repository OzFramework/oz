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

      request_info(endpoint, args)
      @response = HTTPI.request(type, @request, adapter = @adapter)
    end

    def request_info(endpoint, args)
      args = args[0]
      authenticate(args[:auth_type], args) unless args[:auth_type].nil?
      @adapter = args[:adapter] unless args[:adapter].nil?
      #This is used to since we don't have any security :(
      @request.auth.ssl.verify_mode = :none
      @request.url = endpoint
      @request.body = args[:body] unless args[:body].nil?
      @request.headers = args[:headers] unless args[:headers].nil?
      @request.query = args[:query] unless args[:query].nil?
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
    def raw_body
      fail "Must have a proper request to return the #{__method__}" unless @response.nil?
      @response.raw_body
    end

    def body
      fail "Must have a proper request to return the #{__method__}" unless @response.nil?
      @response.body.to_json
    end

    def hash_body
      fail "Must have a proper request to return the #{__method__}" unless @response.nil?
      JSON.parse(@response.body)
    end

    def code
      fail "Must have a proper request to return the #{__method__}" unless @response.nil?
      @response.code
    end

    def headers
      fail "Must have a proper request to return the #{__method__}" unless @response.nil?
      @response.headers
    end

    def error?
      fail "Must have a proper request to return the #{__method__}" unless @response.nil?
      @response.error?
    end
  end

  class Soap
    #stub for soap services if ever needed
  end
end

call = ApiEngine::Rest.new
response = call.request('https://revenueenterpriseservices.int.igsenergy.net/BillingAccount/GetInformation', :post, body: '{"InvoiceGroupID" : 4899259}')
response.code