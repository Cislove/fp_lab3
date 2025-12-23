defmodule FpLab3.Utils.Printer do


  #TODO: дописать хелп
  def help() do
    IO.puts("Какой то хелп")
  end

  def start() do
    IO.puts("Выход из приложения через Ctrl + c")
    IO.puts("Введите узлы интерполяции")
  end

  def args_pars_error() do
    IO.puts("Неверный формат аргументов, укажите --help при запуске, чтобы получить справку")
  end

  def interpolation_result(method, result) do
    result
    |> Enum.each(fn point -> IO.puts("#{method}: #{point.x} #{point.y}") end)
  end
end
