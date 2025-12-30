defmodule FpLab3 do
  @moduledoc false
  alias FpLab3.Application
  alias FpLab3.Utils.{Parser, Printer}

  def main(args) do
    case Parser.parse_cli_args(args) do
      :help -> Printer.help()
      :error -> Printer.args_pars_error()
      config -> Application.start(config)
    end
  end
end
