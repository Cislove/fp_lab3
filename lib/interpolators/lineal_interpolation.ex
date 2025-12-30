defmodule FpLab3.Interpolators.LinealInterpolation do
  use FpLab3.Interpolators.Interpolation

  @moduledoc false

  @impl true
  def get_name, do: "Линейная интерполяция"

  @impl true
  def get_points_enough, do: 2

  @impl true
  def can_many_points?, do: false

  @impl true
  def interpolate(points, x) when not is_list(x) do
    [{x0, y0}, {x1, y1}] = points

    a = (y1 - y0) / (x1 - x0)
    b = y0 - a * x0

    {x, a * x + b}
  end
end
