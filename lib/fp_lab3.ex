defmodule FpLab3 do
  alias FpLab3.Utils.{Parser, Printer}
  alias FpLab3.Application

  def main(args) do
    case Parser.parse_cli_args(args) do
      :help -> Printer.help()

      :error -> Printer.args_pars_error()

      config -> Application.start(config)
    end
  end
end
