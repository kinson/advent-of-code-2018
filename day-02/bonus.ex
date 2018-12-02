defmodule Bonus do

  def solve do
    ids = data()
    ids
    |> Enum.filter(fn box_id ->
      Enum.find(ids, fn compare_id ->
        distance(
          String.graphemes(box_id),
          String.graphemes(compare_id)
        )
      end) != nil
    end)
  end

  defp distance(a, b, diff \\ 0)

  defp distance([], [], diff), do: diff == 1

  defp distance([ha | ta], [hb | tb], diff) when ha == hb, do: distance(ta, tb, diff)

  defp distance([_ha | ta], [_hb | tb], diff), do: distance(ta, tb, diff + 1)

  defp data do
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
