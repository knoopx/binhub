class PageHeader < Arbre::Component
  builder_method :page_header

  def build(resource_or_collection)
    h1 do
      if resource_or_collection.is_a?(ActiveRecord::Relation)
        text_node resource_or_collection.klass.model_name.human.pluralize
        if resource_or_collection.respond_to?(:total_count)
          small(resource_or_collection.total_count)
        else
          small(resource_or_collection.count)
        end

        if controller.respond_to?(:new)
          small(class: "pull-right") { link_to("New", helpers.new_resource_path, class: "btn btn-primary") }
        end
      else
        if resource_or_collection.respond_to?(:name)
          text_node resource_or_collection.name
          small resource_or_collection.class.model_name.human
        else
          text_node resource_or_collection.class.model_name.human
          small resource_or_collection.id
        end
      end
    end
  end

  def default_class_name
    "page-header"
  end
end

