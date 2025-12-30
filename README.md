# Лабораторная работа №3
**Выполнил**: Рахимов Ильнар (409442)
***
## Выполнение
### Архитектура приложения
```
+---------------------------+
|   Обработка конфигурации  |
|   и аргументов программы  |
+---------------------------+
             |
             | Конфигурация шага и методов
             v
+---------------------------+
| Обработка входного потока |<----+
+---------------------------+     |
             |                    |
             +--------------------+
             |
             | Новая точка
             v
+---------------------------+
|   Валидация новой точки   |
+---------------------------+             +-----------------+
|                           |<------------| Генерация точек |
|       Интерполяция        |             +-----------------+
|                           |-----------+
+---------------------------+  Метод 1  |
             |        |-----------------+
             |        |        Метод 2  |
             |        |-----------------+
             |        |        ...      |
             |        |-----------------+
             |
             |
             | Результаты вычислений
             v
+---------------------------+
|  Печать выходных значений |
+---------------------------+
```
### Ключевые элементы реализации
```elixir
defmodule FpLab3.Interpolators.LinealInterpolation do
  use FpLab3.Interpolators.Interpolation

  @moduledoc false

  @impl true
  def get_name, do: "Линейная интерполяция"

  @impl true
  def get_points_enough, do: 2

  @impl true
  def can_many_points?, do: false

  @impl true
  def interpolate(points, x) when not is_list(x) do
    [{x0, y0}, {x1, y1}] = points

    a = (y1 - y0) / (x1 - x0)
    b = y0 - a * x0

    {x, a * x + b}
  end
end
```
### Интерполяция Лагранжем
```elixir
defmodule FpLab3.Interpolators.LagrangeInterpolation do
  use FpLab3.Interpolators.Interpolation

  @moduledoc false

  @impl true
  def get_name, do: "Интерполяция Лагранжом 3 степени"

  @impl true
  def get_points_enough, do: 4

  @impl true
  def can_many_points?, do: false

  @impl true
  def interpolate(points, x) when not is_list(x) do
    y =
      Enum.reduce(Enum.with_index(points), 0.0, fn {point, i}, acc ->
        acc + elem(point, 1) * lagrange_basis(points, x, i)
      end)

    {x, y}
  end

  defp lagrange_basis(points, x, i) do
    Enum.reduce(Enum.with_index(points), 1.0, fn {point, j}, l_acc ->
      if i != j do
        l_acc * (x - elem(point, 0)) / (elem(Enum.at(points, i), 0) - elem(point, 0))
      else
        l_acc
      end
    end)
  end
end
```
### Главный модуль приложения
```elixir
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
    input = IO.gets("")

    InterpolateServer.apply_point(String.trim(input))
    loop()
  end
end

```
### Модуль интерполяции
```elixir
defmodule FpLab3.Servers.InterpolateServer do
  use GenServer

  @moduledoc false

  alias FpLab3.Servers.OutputServer
  alias FpLab3.Utils.Parser

  def start_link(config) do
    GenServer.start_link(__MODULE__, {[], config}, name: __MODULE__)
  end

  def apply_point(point) do
    GenServer.cast(__MODULE__, {:apply_point, point})
  end

  @impl true
  def init({points, config}) do
    {:ok, {points, config}}
  end

  @impl true
  def handle_cast({:apply_point, point}, {points, config}) do
    case Parser.parse_input(point) do
      :error ->
        handle_error_input("Необходимо вводить координаты в формате: {x y}", {points, config})

      :float_parse_error ->
        handle_error_input("Координаты должны быть числами", {points, config})

      {:ok, point} ->
        proccess_new_point(point, {points, config})
    end
  end

  @impl true
  def handle_info({:interpolation_result, method, result}, state) do
    OutputServer.print(method, result)
    {:noreply, state}
  end

  defp handle_error_input(message, state) do
    IO.puts(message)
    {:noreply, state}
  end

  defp proccess_new_point(point, {old_points, config}) do
    prev_point = List.last(old_points)

    if prev_point != nil and elem(prev_point, 0) >= elem(point, 0) do
      handle_error_input(
        "Следующее значение X должно быть больше предыдущего",
        {old_points, config}
      )
    end

    new_points = old_points ++ [point]

    Enum.each(config.methods, &start_task_for_method(&1, new_points, config))

    {:noreply, {new_points, config}}
  end

  defp start_task_for_method(method, points, config) do
    Task.start(fn ->
      case handle_method(method, points, config) do
        :nothing -> :nothing
        result -> send(__MODULE__, {:interpolation_result, method.get_name, result})
      end
    end)
  end

  defp handle_method(method, points, config) do
    if length(points) >= method.get_points_enough do
      know_points = Enum.take(points, 0 - method.get_points_enough)
      xs = generate_points(List.first(know_points), List.last(know_points), config.step)

      method.interpolate.(know_points, xs)
    else
      :nothing
    end
  end

  defp generate_points({x1, _y1}, {x2, _y2}, step) do
    generate_point(x1, x2, step, [])
  end

  defp generate_point(current, last, step, acc) when current <= last do
    generate_point(current + step, last, step, [current | acc])
  end

  defp generate_point(_, _, _, acc), do: Enum.reverse(acc)
end
```
## Пример работы программы
```
❯ ./fp_lab3 --help
CLI программа для интерполяции. Используйте параметры для запуска:
--method={перечесление методов, либо один метод}. Пример: --method=Lineal,Lagrange
--step={шаг}. Пример: --step=0.5
--help - справка
Указание метода и шага обязательное
```

```
❯ ./fp_lab3 --methods=Lineal,Lagrange --step=0.5
Выход из приложения через Ctrl + c
Введите узлы интерполяции
1 1
3 3
Линейная интерполяция: 1.0 1.0
Линейная интерполяция: 1.5 1.5
Линейная интерполяция: 2.0 2.0
Линейная интерполяция: 2.5 2.5
Линейная интерполяция: 3.0 3.0
4 5
Линейная интерполяция: 3.0 3.0
Линейная интерполяция: 3.5 4.0
Линейная интерполяция: 4.0 5.0
6 7
Линейная интерполяция: 4.0 5.0
Линейная интерполяция: 4.5 5.5
Линейная интерполяция: 5.0 6.0
Линейная интерполяция: 5.5 6.5
Линейная интерполяция: 6.0 7.0
Интерполяция Лагранжом 3 степени: 1.0 1.0
Интерполяция Лагранжом 3 степени: 1.5 1.0
Интерполяция Лагранжом 3 степени: 2.0 1.4000000000000004
Интерполяция Лагранжом 3 степени: 2.5 2.1000000000000005
Интерполяция Лагранжом 3 степени: 3.0 3.0
Интерполяция Лагранжом 3 степени: 3.5 4.000000000000001
Интерполяция Лагранжом 3 степени: 4.0 5.0
Интерполяция Лагранжом 3 степени: 4.5 5.8999999999999995
Интерполяция Лагранжом 3 степени: 5.0 6.6
Интерполяция Лагранжом 3 степени: 5.5 7.0
Интерполяция Лагранжом 3 степени: 6.0 7.0
```

## Вывод
В ходе работы были разработаны и протестированы алгоритмы различных методов интерполяции, а также сопутствующие вспомогательные утилиты.

Достигнуты следующие результаты:

* Создана утилита для асинхронного вычисления интерполяции с использованием параллелизма и серверов OTP.

* Реализованы алгоритмы интерполяции: линейная, Лагранжа и Ньютона, с поддержкой работы с заданным количеством точек.

* Разработаны утилиты для генерации промежуточных точек, проверки корректности входных данных и настройки параметров через CLI.

* Подтверждена корректность работы модулей при различных входных данных

