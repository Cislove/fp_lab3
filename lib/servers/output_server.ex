defmodule FpLab3.Servers.OutputServer do
  use GenServer

  alias FpLab3.Utils.Printer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def print(method, result) do
    GenServer.cast(__MODULE__, {:print, method, result})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:print, method, result}, state) do
    Printer.interpolation_result(method, result)
    {:noreply, state}
  end
end
