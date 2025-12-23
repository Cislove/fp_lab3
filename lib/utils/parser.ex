defmodule FpLab3.Utils.Parser do
  @moduledoc """
  Различные функции валидации
  """

  @separator ";"

  @methods ["linear", "lagrange3", "lagrange4", "newton"]

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

  defp parse_cli_arg("methods" <> method, acc) do
    {:cont, Map.put(acc, :methods, String.split(String.trim(method), " "))}
  end

  defp parse_cli_arg("step" <> step, acc) do
    {:cont, Map.put(acc, :step, String.trim(step))}
  end

  defp parse_cli_arg("help", _) do
    {:halt, :help}
  end
end
