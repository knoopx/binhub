module BinHub
  class ArticleProcessor
    def initialize(regular_expressions, article)
      @regular_expressions, @article = regular_expressions, article
    end

    def call
      @regular_expressions.each do |regular_expression|
        if match = regular_expression.match(@article.subject)
          total_files = match[:total_files] rescue nil
          file_number = match[:file_number] rescue nil

          Release.transaction do
            Release.incomplete.joins(files: :segments).lock(true).find_or_create_by_name_and_poster_and_total_files!(name: match[:name], poster: @article.from, total_files: total_files).tap do |release|
              release.files.incomplete.lock(true).find_or_create_by_name_and_total_segments!(name: match[:filename], number: file_number, total_segments: match[:total_segments]).tap do |file|
                file.segments.lock(true).find_or_create_by_number!(number: match[:segment_number], article: @article, regular_expression: regular_expression)
              end
            end
          end

          break
        end

        @article.update_column(:pending, false)
      end
    end
  end
end