defmodule AnalyseFruitsMP do
  @moduledoc """
  MapReduce solution
  """

  @type mapper_id :: integer
  @type mapper :: {:mapper, mapper_id, String.t()}
  @type reducer_id :: {integer, integer}
  @type children :: [mapper] | [reducer]
  @type reducer :: {:reducer, reducer_id, children}
  @type result :: %{String.t() => integer}

  @spec test(integer) :: {:ok, result} | {:error, term}
  def test(processes_per_level \\ 2) do
    files = [
      "./data/data_1.csv",
      "./data/data_2.csv",
      "./data/data_3.csv"
      # "./data/data_5.csv"
    ]

    start(files, processes_per_level)
  end

  @spec start([String.t()], integer) :: {:ok, result} | {:error, term}
  def start(files, processes_per_level \\ 4) do
    # TODO add your implementation
    {:ok, %{}}
  end

  @spec build_processes_tree([String.t()], integer) :: reducer
  def build_processes_tree(files, processes_per_level) do
    file_length = length(files)

    {:reducer, {1, file_length},
     Enum.with_index(files)
     |> Enum.map(fn {file, index} ->
       {:mapper, index + 1, file}
     end)
     |> genereate_reducer(processes_per_level)}
  end

  defp genereate_reducer(list, processes_per_level) do
    file_length = length(list)

    cond do
      processes_per_level < file_length ->
        list =
          if processes_per_level == 2 do
            middle_index = div(length(list), 2)

            Enum.split(list, middle_index)
            |> Tuple.to_list()
          else
            # TODO: check this
            Enum.chunk_every(list, processes_per_level)
          end

        Enum.map(list, fn x ->
          id1 = List.first(x) |> elem(1)
          id2 = List.last(x) |> elem(1)
          {:reducer, {id1, id2}, genereate_reducer(x, processes_per_level)}
        end)

      true ->
        list
    end
  end

  defmodule Coordinator do
    # TODO add your implementation
  end

  defmodule Mapper do
    # TODO add your implementation
  end

  defmodule Reducer do
    # TODO add your implementation
  end
end
