class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :reload_components

  def reload_components
    Dir.glob(Rails.root.join("app/components/**/*.rb")).each do |file|
      require_dependency(file)
    end
  end

  def current_scope
    params.fetch(:scope, :scoped)
  end

  helper_method :current_scope

  def end_of_association_chain_with_includes
    end_of_association_chain_without_includes.includes(self.class.includes)
  end

  def end_of_association_chain_with_pagination
    if self.class.paginate
      end_of_association_chain_without_pagination.page(params[:page])
    else
      end_of_association_chain_without_pagination
    end
  end

  def end_of_association_chain_with_current_scope
    if resource_class.respond_to?(current_scope)
      end_of_association_chain_without_current_scope.send(current_scope)
    else
      raise "Unknown scope :#{current_scope} for #{resource_class}"
    end
  end

  def self.inherit_resources
    super

    class_attribute :paginate
    self.paginate = true

    class_attribute :includes
    self.includes = {}

    alias_method_chain :end_of_association_chain, :current_scope
    alias_method_chain :end_of_association_chain, :pagination
    alias_method_chain :end_of_association_chain, :includes
  end
end
