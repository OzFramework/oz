require 'rspec'

require_relative '../world_gadgets/api_engine'

describe ApiEngine do
  context 'Rest Calls' do

    before(:all) do
      @call = ApiEngine::Rest.new
    end

    it '.request - get' do
      @call.request('https://postman-echo.com/get?foo1=bar1&foo2=bar2', :get)
      expect(@call.code).to eq(200)
      expect(@call.body.length).to be > 0
    end

    it '.request - post' do
      @call.request('https://postman-echo.com/post', :post)
      expect(@call.code).to eq(200)
      expect(@call.body.class).to be(String)
    end

    it 'returns a proper error code' do
      @call.request('https://postman-echo.com/get?foo1=bar1&foo2=bar2', :post, :body => {CutestId: 63})
      expect(@call.error?).to be true
    end

    it 'returns a proper response code' do
      @call.request('https://postman-echo.com/get?foo1=bar1&foo2=bar2', :get)
      expect(@call.code.class).to be(Integer)
    end

    it 'body should be a hash' do
      @call.request('https://postman-echo.com/get?foo1=bar1&foo2=bar2', :get)
      expect(@call.code).to eq(200)
      expect(@call.body_hash.class).to be(Hash)
    end

    it 'body should be a String' do
      @call.request('https://postman-echo.com/get?foo1=bar1&foo2=bar2', :get)
      expect(@call.code).to eq(200)
      expect(@call.body.class).to be(String)
    end

  end


end