module Gouncer
  class Client

    attr_accessor :url, :system, :authorization

    def initialize(config)
      unless config.nil?
        self.url = config[:url]
        self.system = config[:system]
        self.authorization = config[:authorization]
      end
    end

    def authorize
      uri = URI("#{url}/authorize/")
      req = Net::HTTP::Post.new(uri)
      req.body = { system: system}.to_json
      req.content_type = 'application/json'
      req['Authorization'] = authorization

      response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == "https") do |http|
        http.request(req)
      end
    end

  end
end
