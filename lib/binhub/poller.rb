require 'binhub/block_queue'
require 'binhub/threaded_consumer'
require 'binhub/group_fetcher'

module BinHub
  class Poller
    def initialize(sleep_time = 5.minutes)
      @sleep_time = sleep_time
      @slice_size = 500
      @backfill = 1000
    end

    def run
      loop do
        fetch_queue = BlockQueue.new
        process_queue = BlockQueue.new
        regular_expressions = RegularExpression.all

        Article.pending.find_each do |article|
          process_queue.push(BinHub::ArticleProcessor.new(regular_expressions, article))
        end

        Group.find_each do |group|
          fetch_queue.push(GroupFetcher.new(fetch_queue, process_queue, regular_expressions, group, backfill: @backfill, slice_size: @slice_size))
        end

        fetch_consumer = ThreadedConsumer.start(fetch_queue, 10)
        process_consumer = ThreadedConsumer.start(process_queue, 1)
        fetch_consumer.shutdown
        process_consumer.shutdown

        sleep @sleep_time
      end
    end
  end
end