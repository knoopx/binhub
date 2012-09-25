class Reference < ActiveRecord::Base
  attr_accessible :number, :article, :group

  belongs_to :article
  belongs_to :group

  validates_presence_of :number
end