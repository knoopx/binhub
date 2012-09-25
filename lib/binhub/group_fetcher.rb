require 'binhub/nntp'
require 'binhub/overview_fetcher'

module BinHub
  class GroupFetcher
    def initialize(fetch_queue, process_queue, regular_expressions, group, opts = {})
      @backfill = opts.fetch(:backfill, 100000)
      @slice_size = opts.fetch(:slice_size, 500)
      @fetch_queue, @process_queue = fetch_queue, process_queue
      @regular_expressions, @group = regular_expressions, group
    end

    def call
      NNTP.establish_connection do |nntp|
        article_range(nntp).each_slice(@slice_size) do |slice|
          @fetch_queue.push(OverviewFetcher.new(@fetch_queue, @process_queue, @regular_expressions, @group, slice.first, slice.last))
        end
      end
    end

    def article_range(nntp)
      @article_range ||= begin
        total_messages, first_message, last_message = nntp.group(@group.name)

        if @group.last_reference
          pending = last_message - @group.last_reference.number
          if pending > 0
            from_message = @group.last_reference.number
            puts "[#{@group.name}] Last article #{@group.last_reference.number}. Fetching #{pending} [#{from_message}-#{last_message}] new articles..."
          else
            puts "[#{@group.name}] No new articles to fetch."
            return []
          end
        else
          from_message = last_message - @backfill
          puts "[#{@group.name}] No articles fetched, backfilling from the lastest #{@backfill} articles [#{from_message}-#{last_message}]"
        end

        (from_message..last_message)
      end
    end
  end
end