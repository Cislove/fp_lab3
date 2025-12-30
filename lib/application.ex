defmodule FpLab3.Application do
  @moduledoc false
  alias FpLab3.Servers.{InterpolateServer, OutputServer}
  alias FpLab3.Utils.Printer

  def start(config) do
    Printer.start()

    {:ok, _interpolate_server_pid} = InterpolateServer.start_link(config)
    {:ok, _output_server_pid} = OutputServer.start_link()

    loop()
  end

  defp loop do
    # :io.setopts(:standard_io, active: false)
    input = IO.gets("")

    InterpolateServer.apply_point(String.trim(input))
    loop()
  end
end
