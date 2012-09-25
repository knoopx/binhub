class Article < ActiveRecord::Base
  attr_accessible :date, :from, :lines, :size, :subject, :uid

  belongs_to :segment, class_name: "Release::File::Segment"

  has_many :references
  has_many :groups, through: :references, uniq: true

  validates_presence_of :date, :from, :lines, :size, :subject, :uid

  default_scope -> { order(arel_table[:created_at].desc) }
  scope :pending, -> { where(pending: true) }
  scope :processed, -> { where(arel_table[:segment_id].not_eq(nil)) }
  scope :unprocessed, -> { where(segment_id: nil) }

  def nzb_uid
    self.uid[/<([^\>]+)>/, 1]
  end
end
