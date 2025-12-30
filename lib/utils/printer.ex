defmodule FpLab3.Utils.Printer do
  @moduledoc false
  def help do
    IO.puts("CLI программа для интерполяции. Используйте параметры для запуска:")
    IO.puts("--method={перечесление методов, либо один метод}. Пример: --method=Lineal,Lagrange")
    IO.puts("--step={шаг}. Пример: --step=0.5")
    IO.puts("--help - справка")
    IO.puts("Указание метода и шага обязательное")
  end

  def start do
    IO.puts("Выход из приложения через Ctrl + c")
    IO.puts("Введите узлы интерполяции")
  end

  def args_pars_error do
    IO.puts("Неверный формат аргументов, укажите --help при запуске, чтобы получить справку")
  end

  def interpolation_result(method, result) do
    result
    |> Enum.each(fn {x, y} -> IO.puts("#{method}: #{x} #{y}") end)
  end
end
