defmodule FpLab3.Application do

  alias DialyxirVendored.Output
  alias FpLab3.Utils.Printer
  alias FpLab3.Servers.{InterpolateServer, OutputServer}
  def start(config) do
    Printer.start()

    {:ok, interpolate_server_pid} = InterpolateServer.start_link(config)
    {:ok, _output_server_pid} = OutputServer.start_link()

    loop(interpolate_server_pid)
  end

  defp loop(interpolate_server_pid) do
    :io.setopts(:standard_io, active: true)
    input = IO.gets("")

    GenServer.cast(interpolate_server_pid, {:apply_input, String.trim(input)})
    loop(interpolate_server_pid)
  end

end
