module Util
  class DistanceCalculator
    attr_reader :start_position, :object_position

    def initialize(start_position, object_position)
      @start_position = start_position
      @object_position = object_position
    end

    def y_distance
      start_position[:y] - object_position[:y]
    end

    def x_distance
      start_position[:x] - object_position[:x]
    end

    def manhattan_distance
      y_distance.abs + x_distance.abs
    end
  end
end
