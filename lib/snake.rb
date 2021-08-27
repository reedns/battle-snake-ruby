class Snake
  attr_accessor :head, :body

  def initialize(coords)
    @head = coords[:head]
    @body = coords[:body]
  end
end
