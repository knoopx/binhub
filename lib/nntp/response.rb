module NNTP
  class Response
    attr_accessor :code, :message, :body

    def initialize(code, message)
      @code, @message = code, message
    end

    def self.parse(msg)
      code, message = msg.strip.split(" ", 2)
      self.new(code.to_i, message)
    end
  end
end
