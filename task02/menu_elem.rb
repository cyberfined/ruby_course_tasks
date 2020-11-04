class MenuElem
  attr_reader :title, :handler

  def initialize(title, handler)
    @title = title
    @handler = handler
  end
end
