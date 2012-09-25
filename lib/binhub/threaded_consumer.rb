module BinHub
  class ThreadedConsumer
    def self.start(queue, consumers = 10)
      new(queue).start(consumers)
    end

    def initialize(queue)
      @queue = queue
    end

    def start(consumers = 10)
      @threads = consumers.times.map do
        Thread.new do
          while job = @queue.pop
            begin
              job.call
            rescue Exception => e
              handle_exception e
            end
          end
        end
      end
      self
    end

    def shutdown
      @threads.size.times { @queue.push(nil) }
      @threads.map(&:join)
    end

    def handle_exception(e)
      puts "Job Error: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end
end