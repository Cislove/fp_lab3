defmodule FpLab3.Interpolators.LagrangeInterpolation do

  use FpLab3.Interpolators.Interpolation

  @impl true
  def get_name, do: "Интерполяция Лагранжом 3 степени"

  @impl true
  def get_points_enough(), do: 4

  @impl true
  def interpolate(points, x) when not is_list(x) do
    y = Enum.reduce(Enum.with_index(points), 0.0, fn {{xi, yi}, i}, acc ->
      li = Enum.reduce(Enum.with_index(points), 1.0, fn {{xj, _}, j}, l_acc ->
        if i != j do
          l_acc * (x - xj) / (xi - xj)
        else
          l_acc
        end
      end)
      acc + yi * li
    end)

    {x, y}
  end
end
