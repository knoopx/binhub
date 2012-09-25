require 'socket'
require 'nntp/response'
require 'nntp/article'

module NNTP
  class Connection
    NNTPException = Class.new(Exception)
    ServiceUnavailableException = Class.new(NNTPException)

    include Socket::Constants

    attr_accessor :socket
    attr_reader :response

    def initialize(server, port = 119)
      @server = server
      @port = port

      reconnect
      self.socket = Socket.new(AF_INET, SOCK_STREAM, 0)

      begin
        socket.connect(Socket.pack_sockaddr_in(@port, @server))
      rescue Errno::EAFNOSUPPORT
        self.socket = Socket.new(AF_INET6, SOCK_STREAM, 0)
        retry
      end

      response = Response.parse(socket.readline)

      if response.code == 400 || response.code == 502
        raise ServiceUnavailableException.new(response.message)
      end
    end

    def close
      socket.close unless closed?
    end

    def closed?
      socket.closed?
    end

    def reconnect
      self.socket = Socket.new(AF_INET, SOCK_STREAM, 0)

      begin
        socket.connect(Socket.pack_sockaddr_in(@port, @server))
      rescue Errno::EAFNOSUPPORT
        self.socket = Socket.new(AF_INET6, SOCK_STREAM, 0)
        retry
      end

      response = Response.parse(socket.readline)

      if response.code == 400 || response.code == 502
        raise ServiceUnavailableException.new(response.message)
      end
    end

    def mode_reader
      ask('MODE READER')
    end

    def article(message_id)
      ask("ARTICLE #{message_id}")
      if response.code == 220
        return Article.parse(read_multiline)
      end
      false
    end

    def head(message_id)
      ask("HEAD #{message_id}")
      if response.code == 221
        return Article.parse(read_multiline)
      end
      false
    end

    def help
      socket.write("HELP\r\n")
      @response = Response.parse(socket.readline)
      if response.code == 100
        @response.body = read_multiline
        return @response
      end

      false
    end

    # active messages, the low-water mark, the high-water mark
    def group(newsgroup)
      ask("GROUP #{newsgroup}")
      if response.code == 211
        # 1371680046 371770795 1743450840 alt.binaries.cores
        total_messages, first_message, last_message, name = response.message.split(" ")
        [total_messages.to_i, first_message.to_i, last_message.to_i, name]
      else
        false
      end
    end

    def xover(first, last = nil)
      ask("XOVER #{[first, last].compact.join("-")}")
      if response.code == 224
        Enumerator.new do |yielder|
          read_multiline do |line|
            yielder.yield(line.chop.split("\t"))
          end
        end
      end
    end

    def auth(username, password)
      ask("AUTHINFO USER #{username}")

      if response.code == 281
        return true
      elsif response.code == 381
        ask("AUTHINFO PASS #{password}")
        if response.code == 281
          return true
        end
      end

      false
    end

    def read_multiline(limit = nil)
      count, buffer = 0, String.new
      while true
        read = socket.readline
        count += 1
        break if count == limit || read.strip == '.'
        buffer += read
        yield(read) if block_given?
      end
      buffer
    end

    def ask(message)
      socket.write("#{message}\r\n")
      @response = Response.parse(socket.readline)
    end
  end
end
