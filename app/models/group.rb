class Group < ActiveRecord::Base
  attr_accessible :name

  has_many :references, uniq: true
  has_many :articles, through: :references, uniq: true

  validates_presence_of :name
  validates_uniqueness_of :name

  default_scope order(arel_table[:name].asc)

  def last_reference
    self.references.order(Reference.arel_table[:number].desc).limit(1).first
  end
end
