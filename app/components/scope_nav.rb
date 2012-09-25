class ScopeNav < Navigation
  builder_method :scope_nav

  def build(opts = {}, &block)
    super(opts)
  end

  def default
    item(options_for('')) { link_to "All", url_for(scope: nil) }
  end

  def scope(name)
    raise "Unkowwn scope :#{name} for #{resource_class}" unless resource_class.respond_to?(name)
    item(options_for(name)) do
      a(href: url_for(scope: name)) do
        span(controller.send(:end_of_association_chain).except(:limit).send(name).count, class: "badge")
        text_node name.to_s.humanize
      end
    end
  end

  def options_for(scope)
    opts = {}
    opts[:active] = true if params[:scope].to_s == scope.to_s
    opts
  end
end