class DescriptionFor < Arbre::Component
  builder_method :description_for

  def build(resource, options = {})
    @resource = resource
    add_class "dl-horizontal" if options.delete(:horizontal)
    super(options)
  end

  def column(name, value_or_block = nil, &block)
    add_child dt(@resource.class.human_attribute_name(name))

    if block_given?
      add_child dd(block.call(@resource))
    else
      if value_or_block.nil?
        add_child dd(@resource.send(name))
      else
        add_child dd(value_or_block)
      end
    end
  end

  def tag_name
    "dl"
  end
end