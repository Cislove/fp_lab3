defmodule FpLab3.Application do

  alias FpLab3.Utils.Printer
  alias FpLab3.Servers.{InterpolateServer, OutputServer}
  def start(config) do
    Printer.start()

    {:ok, _interpolate_server_pid} = InterpolateServer.start_link(config)
    {:ok, _output_server_pid} = OutputServer.start_link()

    loop()
  end

  defp loop() do
    # :io.setopts(:standard_io, active: false)
    input = IO.gets("")

    InterpolateServer.apply_point(String.trim(input))
    loop()
  end

end
