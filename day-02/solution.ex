defmodule Solution do

  def solve do
    data()
    |> Enum.reduce([0, 0],
      fn x, acc ->
        [two, three] = count(x)
        [
          List.first(acc) + two,
          List.last(acc) + three
        ]
      end
    )
    |> multiply()
  end

  defp multiply([first, second]), do: first * second

  defp count(code) do
    code
    |> String.graphemes
    |> Enum.reduce(%{},
      fn x, acc ->
        case Map.has_key?(acc, x) do
          true -> Map.put(acc, x, Map.get(acc, x) + 1)
          false -> Map.put(acc, x, 1)
        end
      end
    )
    |> patterns()
  end

  defp patterns(letters) do
    [
      deduce(letters, 2),
      deduce(letters, 3)
    ]
  end

  defp deduce(letters, count) do
    letters 
    |> Enum.reduce(0, fn {k, v}, acc ->
      case v == count do
        true -> 1
        false -> acc
      end
    end) 
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
