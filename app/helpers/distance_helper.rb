# frozen_string_literal: true

module Helpers
  module DistanceHelper
    def calculate_euclidean_distance(point_a_x, point_a_y, point_b_x, point_b_y)
      Math.sqrt(square_distance(point_a_x, point_a_y, point_b_x, point_b_y)).round(4)
    end

    def square_distance(point_a_x, point_a_y, point_b_x, point_b_y)
      ((point_b_x - point_a_x)**2) + ((point_b_y - point_a_y)**2)
    end
  end
end
