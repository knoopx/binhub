class RegularExpression < ActiveRecord::Base
  NAMED_CAPTURES = [:name, :filename, :segment_number, :total_segments] #:file_number, :total_files

  attr_accessible :value, :priority, :process_placeholders
  has_many :segments, class_name: Release::File::Segment, dependent: :destroy

  validates_presence_of :value

  default_scope order(arel_table[:priority].asc)

  validate do
    begin
      NAMED_CAPTURES.map(&:to_s).each do |capture|
        errors.add(:value, "does not include a #{capture} group") unless regex.named_captures.include?(capture)
      end
    rescue => e
      errors.add(:value, e.message)
    end
  end

  def match(value)
    regex.match(value)
  end

  def regex
    @regex ||= begin
      if self.process_placeholders?
        new_value = Regexp.escape(self.value).gsub(/(\\ )+/, "\\s+").gsub(/:\w+/) do |match|
          field = match.from(1).to_sym
          case field
            when :name, :filename
              "(?<#{field}>.+)"
            when :file_number, :total_files, :segment_number, :total_segments
              "(?<#{field}>\\d+)"
            when :whatever
              ".*"
            else
              raise "Unknown placeholder: #{match}"
          end
        end

        Regexp.new("^#{new_value}$")
      else
        Regexp.new(self.value)
      end
    end
  end
end
