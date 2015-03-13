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
      response = Typhoeus::Request.new(
        "#{url}/authorize",
        method: "post",
        body: { system: system }.to_json,
        ssl_verifypeer: false,
        headers: { Authorization: authorization }, # Contents from the Authorization header
      ).run
    end

  end
end
