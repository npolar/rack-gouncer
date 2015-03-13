module Rack
  class Gouncer

    # Config takes two options:
    # url: "the url to the auth server"
    # system: "the system you want to authorize"
    # open: "true | false depending on the fact that the api is open or not"

    def initialize(app=nil, options={})
      # Return a 500 error when no app is provided
      app = lambda{|env| [500, {"Content-Type" => "application/json"} [{"error" => "500 internal server error"}]]} if app.nil?

      @app, @config = app, options
    end

    def call(env)
      @env = env

      # Call gouncer with the system and the token
      if @config['open'] && read?
        return @app.call(env)
      elsif authorization?
        @config[:authorization] = env['HTTP_AUTHORIZATION']
        @response = client.authorize

        if @response.code == 200
          body = JSON.parse(@response.body)

          case env['REQUEST_METHOD']
          when "GET" then
            return @app.call(env) if body["rights"].include?('read')
          when "PUT" then
            return @app.call(env) if body['rights'].include?('update')
          when "POST" then
            return @app.call(env) if body['rights'].include?('create')
          when "DELETE" then
            return @app.call(env) if body['rights'].include?('delete')
          end
          # Bleed the auth server error?
        end
      end

      return [401, {"Content-Type" => "application/json"}, [{error: @response.body}.to_json]]

    end

    def client
      ::Gouncer::Client.new(@config)
    end

    def authorization?
      return @env['HTTP_AUTHORIZATION'] =~ /^Bearer\s[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+|Basic\s[a-zA-Z0-9_=]+/
    end

    def read?
      return ["GET","HEAD","OPTIONS"].include?( @env['REQUEST_METHOD'] )
    end

  end
end
