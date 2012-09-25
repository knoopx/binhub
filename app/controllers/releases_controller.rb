class ReleasesController < ApplicationController
  respond_to :html, :nzb
  inherit_resources
  actions :all, except: [:new, :create]
  self.includes = :groups

  after_filter :send_nzb_headers, only: :show, if: :nzb?

  def send_nzb_headers
    send_file_headers! filename: "#{resource.name}.nzb", disposition: 'inline'
  end

  def nzb?
    request.format == :nzb
  end
end
