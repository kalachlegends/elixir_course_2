defmodule Helper do
end

defmodule ListSplitter do
  @spec split_into_parts(list(), integer()) :: [list()]
  def split_into_parts(list, num_parts) do
    total_length = length(list)
    chunk_size = div(total_length, num_parts)
    remainder = rem(total_length, num_parts)

    # Разделение основной части списка на равные части
    main_chunks = Enum.chunk_every(list, chunk_size)

    # Если есть остаток, добавить его к последним частям
    if remainder > 0 do
      Enum.chunk_every(list, chunk_size + 1, chunk_size + 1, :discard)
    else
      main_chunks
    end
  end
end
