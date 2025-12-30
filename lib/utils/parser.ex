defmodule FpLab3.Utils.Parser do
  @moduledoc """
  Различные функции валидации
  """

  @separator " "

  @spec parse_input(input:: String.t()) :: {atom(), {any(), any()}} | atom()
  def parse_input(input) do
    case String.split(input, @separator) do
      [x, y] ->
        with {x, ""} <- Float.parse(x),
             {y, ""} <- Float.parse(y) do

          {:ok, {x, y}}
        else
          _ -> :float_parse_error
        end

      _ -> :error
    end
    # require IEx
    # IEx.pry()
  end

  @spec parse_cli_args(args :: [String.t()]) :: %{optional(atom()) => any()}
  def parse_cli_args(args) do
    args
    |> Enum.reduce_while(%{}, fn arg, acc ->
      case parse_cli_arg(arg, acc) do
        {:halt, value} -> {:halt, value}
        {:cont, new_acc} -> {:cont, new_acc}
      end
    end)
  end

  defp parse_cli_arg("--methods=" <> method, acc) do
    methods = Enum.map(String.split(String.trim(method), " "),
                fn module -> Module.concat(["FpLab3", "Interpolators", "#{String.capitalize(module)}Interpolation"])
                end)

    {:cont, Map.put(acc, :methods, methods)}
  end

  defp parse_cli_arg("--step=" <> step, acc) do
    {step_value, _} = Float.parse(String.trim(step))
    {:cont, Map.put(acc, :step, step_value)}
  end

  defp parse_cli_arg("--help", _) do
    {:halt, :help}
  end
end
