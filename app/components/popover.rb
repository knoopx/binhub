class Popover < Arbre::Component
  builder_method :popover

  def build(title, content, opts = {}, &block)
    super(title, opts.merge(rel: "popover", "data-original-title" => title, "data-content" => content), &block)
  end

  def tag_name
    "a"
  end
end