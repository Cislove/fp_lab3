defmodule FpLab3.Interpolators.LagrangeInterpolation do
  use FpLab3.Interpolators.Interpolation

  @moduledoc false

  @impl true
  def get_name, do: "Интерполяция Лагранжом 3 степени"

  @impl true
  def get_points_enough, do: 4

  @impl true
  def can_many_points?, do: false

  @impl true
  def interpolate(points, x) when not is_list(x) do
    y =
      Enum.reduce(Enum.with_index(points), 0.0, fn {point, i}, acc ->
        acc + elem(point, 1) * lagrange_basis(points, x, i)
      end)

    {x, y}
  end

  defp lagrange_basis(points, x, i) do
    Enum.reduce(Enum.with_index(points), 1.0, fn {point, j}, l_acc ->
      if i != j do
        l_acc * (x - elem(point, 0)) / (elem(Enum.at(points, i), 0) - elem(point, 0))
      else
        l_acc
      end
    end)
  end
end
