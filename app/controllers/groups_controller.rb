class GroupsController < ApplicationController
  inherit_resources
  self.paginate = false
  actions :all, except: :show
end