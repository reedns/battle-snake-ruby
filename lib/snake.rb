class Snake
  attr_accessor :head, :body, :length, :health

  def initialize(data)
    @head = data[:head]
    @body = data[:body]
    @length = data[:length]
    @health = data[:length]
  end
end
