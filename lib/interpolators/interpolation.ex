defmodule FpLab3.Interpolators.Interpolation do

  @callback interpolate(points :: [tuple()], target_point :: number()) :: number()
  @callback get_name() :: binary()
  @callback get_points_enough() :: number()
  @callback can_many_points?() :: boolean()

  defmacro __using__(_) do
    quote do
      @behaviour FpLab3.Interpolators.Interpolation

      @impl true
      def interpolate(points, xs) when is_list(xs) do
        Enum.map(xs, fn x -> interpolate(points, x) end)
      end
    end
  end
end
