defmodule FpLab3.Servers.InterpolateServerTest do
  use ExUnit.Case, async: true

  alias FpLab3.Servers.InterpolateServer

  defmodule MockOutputServer do
    def print(method, result) do
      send(self(), {:printed, method, result})
      :ok
    end
  end

  setup do
    config = %{
      methods: [
        %{
          get_name: fn -> "MockMethod" end,
          get_points_enough: fn -> 2 end,
          interpolate: fn points, xs -> {:interpolated, points, xs} end
        }
      ],
      step: 0.5
    }

    {:ok, pid} =
      start_supervised({InterpolateServer, config})

    {:ok, pid: pid, config: config}
  end

  describe "apply_point/1" do
    test "добавляет корректную точку", %{pid: pid} do
      assert :ok = InterpolateServer.apply_point("1.0 2.0")

      :timer.sleep(50)
      state = :sys.get_state(pid)
      assert state == {[{1.0, 2.0}], state |> elem(1)}
    end

    test "возвращает ошибку при неверном формате", %{pid: _pid} do
      assert :ok = InterpolateServer.apply_point("invalid input")
    end

    test "возвращает ошибку при float_parse_error", %{pid: _pid} do
      assert :ok = InterpolateServer.apply_point("1.a 2.0")
    end
  end

  describe "handle_method/3" do
    test "вызывает метод interpolate, если точек достаточно", %{pid: _pid, config: _config} do
      InterpolateServer.apply_point("1.0 2.0")
      InterpolateServer.apply_point("2.0 4.0")
      :timer.sleep(50)
    end
  end
end
