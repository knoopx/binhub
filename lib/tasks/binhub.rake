require 'binhub/poller'
require 'binhub/block_queue'
require 'binhub/threaded_consumer'

namespace :binhub do
  task :poll => :environment do
    Rails.logger = Logger.new('/dev/null')
    BinHub::Application.eager_load!
    BinHub::Poller.new.run
  end

  task :reprocess => :environment do
    Rails.logger = Logger.new('/dev/null')
    BinHub::Application.eager_load!

    regular_expressions = RegularExpression.all
    queue = BinHub::BlockQueue.new

    Article.unprocessed.find_each do |article|
      queue.push(BinHub::ArticleProcessor.new(regular_expressions, article))
    end

    consumer = BinHub::ThreadedConsumer.start(queue, 4)
    consumer.shutdown
  end
end