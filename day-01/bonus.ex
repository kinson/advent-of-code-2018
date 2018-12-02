defmodule Bonus do
  def solve do
    traverse(0, clean(), %{0 => true})
  end

  def traverse(sum, [], totals) do
    traverse(sum, clean(), totals)
  end

  def traverse(sum, [a | tail], totals) do
    new_sum = sum + a
    case Map.has_key?(totals, new_sum) do
      true  -> new_sum
      false -> traverse(new_sum, tail, Map.put(totals, new_sum, true))
    end
  end

  def clean do
    read_file()
    |> String.split("\n")
    |> Enum.filter(&not_empty?/1)
    |> Enum.map(&String.to_integer/1)
  end

  defp read_file do
    case File.read("input.txt") do
      {:ok, data} -> data
      {_, _error} -> IO.puts "error reading input file"
    end
  end

  defp not_empty?(string), do: String.length(string) > 0
end
