require 'nntp/connection'

module BinHub
  module NNTP
    class << self
      attr_accessor :server_address, :server_port
      attr_accessor :server_username, :server_password

      def configure
        yield(self)
      end

      def establish_connection
        connection = ::NNTP::Connection.new(self.server_address, self.server_port)
        connection.auth(self.server_username, self.server_password)
        yield(connection)
      ensure
        connection.try(:close)
      end
    end
  end
end