defmodule FpLab3.Servers.InterpolateServer do
  use GenServer

  alias FpLab3.Servers.OutputServer
  alias FpLab3.Utils.{Parser}

  def start_link(config) do
    GenServer.start_link(__MODULE__, {[], config}, name: __MODULE__)
  end

  def apply_point(point) do
    GenServer.cast(__MODULE__, {:apply_point, point})
  end

  @impl true
  def init({points, config}) do
    {:ok, {points, config}}
  end

  @impl true
  def handle_cast({:apply_point, point}, {points, config}) do
    case Parser.parse_input(point) do
      :error -> handle_error_input("Необходимо вводить координаты в формате: {x y}", {points, config})

      :float_parse_error -> handle_error_input("Координаты должны быть числами", {points, config})

      {:ok, point} -> proccess_new_point(point, {points, config})
    end
  end

  @impl true
  def handle_info({:interpolation_result, method, result}, state) do
    OutputServer.print(method, result)
    {:noreply, state}
  end

  defp handle_error_input(message, state) do
    IO.puts(message)
    {:noreply, state}
  end

  defp proccess_new_point(point, {old_points, config}) do
    prev_point = List.last(old_points)
    if prev_point != nil and elem(prev_point, 0) >= elem(point, 0) do
      handle_error_input("Следующее значение X должно быть больше предыдущего", {old_points, config})
    end

    new_points = old_points ++ [point]

    Enum.each(config.methods, fn method ->
      Task.start(fn ->
        case handle_method(method, new_points, config) do
          :nothing -> :nothing

          result -> send(__MODULE__, {:interpolation_result, method.get_name, result})
        end
      end)
    end)

    {:noreply, {new_points, config}}
  end

  defp handle_method(method, points, config) do
    if(length(points) >= method.get_points_enough) do
      know_points = Enum.take(points, 0 - method.get_points_enough)
      xs = generate_points(List.first(know_points), List.last(know_points), config.step)

      method.interpolate.(know_points, xs)
    else
      :nothing
    end
  end

  defp generate_points({x1, _y1}, {x2, _y2}, step) do
    generate_point(x1, x2, step, [])
  end

  defp generate_point(current, last, step, acc) when current <= last do
    generate_point(current + step, last, step, [current | acc])
  end

  defp generate_point(_, _, _, acc), do: Enum.reverse(acc)

end
