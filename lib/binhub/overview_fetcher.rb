require 'binhub/nntp'
require 'binhub/article_processor'

module BinHub
  class OverviewFetcher

    def initialize(fetch_queue, process_queue, regular_expressions, group, first, last)
      @fetch_queue, @process_queue = fetch_queue, process_queue
      @group = group
      @regular_expressions = regular_expressions
      @first, @last = first, last
    end

    def call
      NNTP.establish_connection do |nntp|
        nntp.group(@group.name)
        nntp.xover(@first, @last).each do |number, subject, from, date, id, references, size, lines, meta|
          @process_queue.push do
            Article.transaction do
              if article = Article.lock(true).find_or_create_by_uid(subject: subject, from: from, date: date, uid: id, size: size, lines: lines)
                article.references.create(number: number, group: @group)
                # TODO: parse x-ref
                @process_queue.push(BinHub::ArticleProcessor.new(@regular_expressions, article))
              end
            end
          end
        end
      end
    end
  end
end