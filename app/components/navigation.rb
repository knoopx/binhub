class Navigation < Arbre::Component
  builder_method :nav

  def build(opts = {}, &block)
    add_class "nav-#{opts.delete(:style) || :tabs}"
    add_class "nav-stacked" if (opts.delete(:stacked) || false)
    super(opts, &block)
  end

  def item(opts = {}, &block)
    disabled = opts.delete(:disabled) || false
    active = opts.delete(:active) || false
    li(opts) do |el|
      el.add_class "disabled" if disabled
      el.add_class "active" if active
      block.call(self)
    end
  end

  def tag_name
    "ul"
  end

  def default_class_name
    "nav"
  end
end