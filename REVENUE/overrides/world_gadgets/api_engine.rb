require 'httpi'

module ApiEngine
  class Rest
    def initialize
      @request = HTTPI::Request.new
    end

    def request_info(endpoint, *args)
      authenticate(args[:auth_type], args) unless args[:auth_type].nil?
      @adapter = args[:adapter] unless args[:adapter].nil?
      @request.url = endpoint
      @request.body = args[:body] unless args[:body].nil?
      @request.headers = args[:headers] unless args[:headers].nil?
      @request.query = args[:query] unless args[:query].nil?
    end

    def request(endpoint, type, *args)
      fail 'must provide an endpoint' unless endpoint.nil?
      #type can be put, post, get, delete, or head
      fail 'type should be a symbol' unless type.class(Symbol)

      request_info(endpoint, args)
      HTTPI.request(type, @request, adapter = @adapter)
    end

    def authenticate(type, *args)
      case type
      when 'ntlm'
        user = args[:username]
        pass = args[:password]
        domain = args[:domain]
        @request.auth.ntlm(user, pass, domain)
      when 'ssl'
        "ssl cert selected"
      else
        "some other auth"
      end
    end
  end

  class Soap
    #stub for soap services if ever needed
  end
end