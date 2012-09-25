class ArticlesController < ApplicationController
  inherit_resources
  actions :all, except: [:new, :create]
end
