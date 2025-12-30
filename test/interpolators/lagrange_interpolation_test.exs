defmodule FpLab3.Interpolators.LagrangeInterpolationTest do
  use ExUnit.Case

  alias FpLab3.Interpolators.LagrangeInterpolation

  describe "interpolate/2" do
    test "вычисляет y для одного x" do
      points = [{1.0, 1.0}, {2.0, 4.0}, {3.0, 9.0}]
      {x, y} = LagrangeInterpolation.interpolate(points, 1.5)

      assert x == 1.5
      assert_in_delta y, 2.25, 1.0e-10
    end

    test "вычисляет y для нескольких x" do
      points = [{0.0, 0.0}, {1.0, 1.0}, {2.0, 4.0}]
      xs = [0.0, 0.5, 1.0, 1.5, 2.0]

      result = LagrangeInterpolation.interpolate(points, xs)

      expected = [
        {0.0, 0.0},
        {0.5, 0.25},
        {1.0, 1.0},
        {1.5, 2.25},
        {2.0, 4.0}
      ]

      Enum.each(Enum.zip(result, expected), fn {{_x1, y1}, {_x2, y2}} ->
        assert_in_delta y1, y2, 1.0e-10
      end)
    end
  end

  describe "метаданные метода" do
    test "возвращает имя" do
      assert LagrangeInterpolation.get_name() == "Интерполяция Лагранжом 3 степени"
    end

    test "возвращает количество точек" do
      assert LagrangeInterpolation.get_points_enough() == 4
    end

    test "can_many_points? возвращает false" do
      refute LagrangeInterpolation.can_many_points?()
    end
  end
end
