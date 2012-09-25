class ActionsGroup < Arbre::Component
  builder_method :actions_for

  def build(resource)
    div(class: "btn-group") do
      a(class: "btn dropdown-toggle", "data-toggle" => "dropdown") do
        text_node "Action"
        span(class: "caret")
      end

      ul(class: "dropdown-menu") do
        li do
          text_node link_to("Edit", edit_resource_path(resource))
          text_node link_to("Delete", resource, method: :delete, confirm: "Are you sure?")
        end
      end
    end
  end
end