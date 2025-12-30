defmodule FpLab3.Interpolators.LinealInterpolationTest do
  use ExUnit.Case

  alias FpLab3.Interpolators.LinealInterpolation

  describe "interpolate/2" do
    test "вычисляет y для одного x" do
      points = [{1.0, 2.0}, {3.0, 4.0}]
      {x, y} = LinealInterpolation.interpolate(points, 2.0)

      assert x == 2.0
      assert y == 3.0
    end

    test "вычисляет y для нескольких x" do
      points = [{0.0, 0.0}, {2.0, 4.0}]
      xs = [0.0, 1.0, 2.0]

      result = LinealInterpolation.interpolate(points, xs)

      assert result == [
               {0.0, 0.0},
               {1.0, 2.0},
               {2.0, 4.0}
             ]
    end
  end

  describe "метаданные метода" do
    test "возвращает имя" do
      assert LinealInterpolation.get_name() == "Линейная интерполяция"
    end

    test "возвращает количество точек" do
      assert LinealInterpolation.get_points_enough() == 2
    end

    test "can_many_points? возвращает false" do
      refute LinealInterpolation.can_many_points?()
    end
  end
end
