class SegmentsController < ApplicationController
  inherit_resources
  defaults resource_class: Release::File::Segment
  actions :all, except: [:new, :create]
  belongs_to :file, parent_class: Release::File, optional: true
  belongs_to :regular_expression, optional: true
end
