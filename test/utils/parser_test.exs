defmodule FpLab3.Utils.ParserTest do
  use ExUnit.Case

  alias FpLab3.Utils.Parser

  describe "parse_input/1" do
    test "разбирает корректные координаты" do
      assert Parser.parse_input("1.5 2.5") == {:ok, {1.5, 2.5}}
      assert Parser.parse_input("0 0") == {:ok, {0.0, 0.0}}
    end

    test "возвращает :float_parse_error при некорректных числах" do
      assert Parser.parse_input("1.a 2") == :float_parse_error
      assert Parser.parse_input("1 2.b") == :float_parse_error
    end

    test "возвращает :error при неправильном формате" do
      assert Parser.parse_input("1") == :error
      assert Parser.parse_input("1 2 3") == :error
      assert Parser.parse_input("") == :error
    end
  end

  describe "parse_cli_args/1" do
    test "разбирает методы и шаг" do
      args = ["--methods=Lineal,Lagrange", "--step=0.5"]
      result = Parser.parse_cli_args(args)

      assert result.step == 0.5
      assert result.methods == [
               FpLab3.Interpolators.LinealInterpolation,
               FpLab3.Interpolators.LagrangeInterpolation
             ]
    end

    test "обрабатывает только --help" do
      args = ["--help"]
      assert Parser.parse_cli_args(args) == :help
    end

    test "разбирает только один параметр" do
      args = ["--step=1.0"]
      result = Parser.parse_cli_args(args)
      assert result.step == 1.0
      assert Map.get(result, :methods) == nil
    end
  end
end
