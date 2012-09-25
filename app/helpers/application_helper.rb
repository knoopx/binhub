module ApplicationHelper
  def paginate(scope, options = {}, &block)
    super(scope, options.merge(theme: "twitter-bootstrap"), &block)
  end
end
