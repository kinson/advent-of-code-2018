defmodule Solution do

  def solve do
    data()
    |> fill(%{})
    |> count_overlap()
  end

  def bonus do
    d = data()
    ids = id_hash(d)
    d 
    |> fill(%{})
    |> fill_hash(ids)
    |> Enum.find(fn {k, v} -> v == true end)
  end

  defp count_overlap(grid) do
    Enum.reduce(grid, 0, fn ({key, val}, acc) ->
      case val > 1 do
        true -> acc + 1 
        false -> acc
      end
    end)
  end

  def id_hash(rows) do
    total_count = Enum.count(rows)
    Enum.reduce(1..total_count, %{}, &(Map.put(&2, &1, true)))
  end

  def fill_hash(grid, hash) do
    Enum.reduce(grid, hash,
      fn ({key, {c, ids}}, acc) ->
        case c > 1 do
          true -> Enum.reduce(ids, acc, &Map.put(&2, &1, false))
          false -> acc 
        end
      end)
  end

  def fill([], m), do: m

  def fill([ row | tail], m) do
    ## #1 @ 4,4: 4x4
    start_x = start(row, 0)
    start_y = start(row, 1)
    width = size(row, 0)
    height = size(row, 1)
    id = id(row)
    new_grid = Enum.reduce(start_x..(start_x + width - 1), m,
      fn (x, acc) ->
        Enum.reduce(start_y..(start_y + height - 1), acc,
          fn (y, yacc) ->
            cur = Map.get(yacc, key(x, y))
            Map.update(
              yacc,
              key(x, y),
              {1, [id]},
              fn {c, ids} -> {c + 1, [id | ids]} end
            )
          end)
      end)
    fill(tail, new_grid)
  end

  defp start(row, col) do
    String.split(row, " ")
    |> Enum.at(2)
    |> String.split([",", ":"])
    |> Enum.at(col)
    |> String.to_integer()
  end

  defp size(row, col) do
    String.split(row, " ")
    |> Enum.at(3)
    |> String.split("x")
    |> Enum.at(col)
    |> String.to_integer()
  end

  defp id(row) do
    String.split(row, [" ", "#"])
    |> Enum.at(1)
    |> String.to_integer
  end

  defp key(x, y) do
    "#{form(x)},#{form(y)}"
  end

  defp form(coord) do
    Integer.to_string(coord)
    |> String.pad_leading(4, "0")
  end

  def data do
    read_file()
    |> String.split("\n")
    |> Enum.filter(&not_empty?/1)
  end

  defp read_file do
    case File.read("input.txt") do
      {:ok, data} -> data
      {_, _error} -> IO.puts "error reading the file"
    end
  end

  defp not_empty?(string), do: String.length(string) > 0
end
