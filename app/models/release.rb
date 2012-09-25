class Release < ActiveRecord::Base
  class File < ActiveRecord::Base
    class Segment < ActiveRecord::Base
      attr_accessible :number, :article, :regular_expression
      belongs_to :file
      belongs_to :regular_expression, counter_cache: true
      has_one :article, dependent: :nullify

      validates_presence_of :number, :article, :regular_expression, :file

      default_scope order(arel_table[:number].asc)

      after_create { self.file.update_completion! }
    end

    attr_accessible :name, :number, :total_segments

    has_many :segments, dependent: :destroy
    has_many :articles, through: :segments, uniq: true
    belongs_to :release, counter_cache: true, dependent: :destroy

    validates_presence_of :name, :total_segments, :release

    default_scope order(arel_table[:number].asc)

    scope :complete, where(complete: true)
    scope :incomplete, where(complete: false)

    def update_completion!
      if complete?
        self.update_attributes({complete: true, size: self.articles.sum(:size)}, without_protection: true)
        self.release.update_completion!
      end
    end

    def complete?
      self.segments.count >= self.total_segments
    end
  end

  attr_accessible :name, :poster, :total_files

  has_many :segments, through: :files, class_name: Release::File::Segment #, dependent: :destroy
  has_many :files, dependent: :destroy
  has_many :articles, through: :segments, uniq: true
  has_many :regular_expressions, through: :segments, uniq: true

  has_many :references, through: :articles
  has_many :groups, through: :references, uniq: true

  validates_presence_of :name

  default_scope order(arel_table[:created_at].desc)

  scope :complete, where(complete: true)
  scope :incomplete, where(complete: false)

  def update_completion!
    if self.files.count >= total_files && self.files.all?(&:complete)
      self.update_attributes({complete: true, size: self.files.sum(:size)}, without_protection: true)
    end
  end
end
