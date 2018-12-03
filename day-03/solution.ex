defmodule Solution do

  def solve(input_file) do
    data(input_file)
    |> fill(%{})
    |> count_overlap()
  end

  def bonus(input_file) do
    data(input_file)
    |> find_unique_patch() 
  end

  defp find_unique_patch(coords) do
    ids = id_hash(coords)

    coords 
    |> fill(%{})
    |> fill_hash(ids)
    |> Enum.find(fn {_k, v} -> v == true end)
    |> elem(0)
  end

  defp count_overlap(grid) do
    Enum.reduce(grid, 0, fn ({_key, {c, _ids}}, acc) ->
      case c > 1 do
        true -> acc + 1 
        false -> acc
      end
    end)
  end

  defp id_hash(rows) do
    total_count = Enum.count(rows)
    Enum.reduce(1..total_count, %{}, &(Map.put(&2, &1, true)))
  end

  defp fill_hash(grid, hash) do
    Enum.reduce(grid, hash,
      fn ({_key, {c, ids}}, acc) ->
        case c > 1 do
          true -> Enum.reduce(ids, acc, &Map.put(&2, &1, false))
          false -> acc 
        end
      end)
  end

  defp fill([], m), do: m

  defp fill([ row | tail], m) do
    ## #1 @ 4,4: 4x4
    patch = row_details(row)
    fill(
      tail,
      Enum.reduce(patch.x..(patch.x + patch.dx - 1), m,
        fn (x, acc) ->
          Enum.reduce(patch.y..(patch.y + patch.dy - 1), acc,
            fn (y, bcc) ->
              Map.update(
                bcc,
                {x, y},
                {1, [patch.id]},
                fn {c, ids} -> {c + 1, [patch.id | ids]} end
              )
            end)
        end)
    )
  end

  defp row_details(row) do
    %{
      x: from_row(row, start(0)),
      y: from_row(row, start(1)),
      dx: from_row(row, size(0)),
      dy: from_row(row, size(1)),
      id: from_row(row, id())
    }
  end

  defp from_row(row, func) do
    String.split(row, " ")
    |> func.()
    |> String.to_integer()
  end 

  defp start(col) do
    fn(row) ->
      row
      |> Enum.at(2)
      |> String.split([",", ":"])
      |> Enum.at(col)
    end
  end

  defp size(col) do
    fn(row) ->
      row
      |> Enum.at(3)
      |> String.split("x")
      |> Enum.at(col)
    end
  end

  defp id do
    fn row ->
      row
      |> Enum.at(0)
      |> String.split("#")
      |> Enum.at(1)
    end
  end

  def data(input_file) do
    input_file
    |> read_file()
    |> String.split("\n")
    |> Enum.filter(&not_empty?/1)
  end

  defp read_file(file_name) do
    case File.read(file_name) do
      {:ok, data} -> data
      {_, _error} -> IO.puts "error reading the file"
    end
  end

  defp not_empty?(string), do: String.length(string) > 0
end
