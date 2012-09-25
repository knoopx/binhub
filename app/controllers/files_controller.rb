class FilesController < ApplicationController
  inherit_resources
  defaults resource_class: Release::File
  actions :all, except: [:new, :create]
  belongs_to :release, optional: true
end
