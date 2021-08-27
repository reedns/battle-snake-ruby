class Snake
  attr_accessor :head, :body

  def initialize(data)
    @head = data[:head]
    @body = data[:body]
    @length = data[:length]
  end
end
