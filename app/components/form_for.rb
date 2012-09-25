class FormFor < Arbre::Element
  builder_method :form_for

  class Concatenator < SimpleDelegator
    def initialize(obj, buffer)
      @builder, @template = obj, buffer
    end

    def method_missing(method, *args, &block)
      @template.concat @builder.send(method, *args, &block)
    end
  end

  def build(resource, options = {}, &block)
    text_node(simple_form_for(resource, options) { |builder| helpers.instance_exec(Concatenator.new(builder, helpers), &block) })
  end
end
