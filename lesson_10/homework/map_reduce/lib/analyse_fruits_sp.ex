defmodule AnalyseFruitsSP do
  @moduledoc """
  Single process solution
  """

  @type result :: %{String.t() => integer}

  @spec start() :: result
  def start() do
    start([
      "./data/data_1.csv",
      "./data/data_2.csv",
      "./data/data_3.csv"
    ])
  end

  @spec start([String.t()]) :: result
  def start(files) do
    Enum.reduce(files, %{}, fn path, acc ->
      map =
        File.read!(path)
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))
        |> Enum.reduce(%{}, &handle_count/2)

      handle_count_acc(acc, map)
    end)
  end

  defp handle_count_acc(acc_from_files, map) do
    Enum.reduce(map, acc_from_files, fn {key, value}, acc ->
      {_, map} =
        Map.get_and_update(acc, key, fn x ->
          case x do
            nil ->
              {x, String.to_integer(value)}

            int ->
              {x, int + String.to_integer(value)}
          end
        end)

      map
    end)
  end

  defp handle_count(e, acc) do
    case e do
      [_, name, cost, _] ->
        Map.get_and_update(acc, name, fn x ->
          case x do
            nil ->
              {x, cost}

            int ->
              {x, int + String.to_integer(cost)}
          end
        end)
        |> elem(1)

      _ ->
        acc
    end
  end
end
