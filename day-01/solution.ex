defmodule Solution do

  @in "input.txt"

  def solve do
    read_file()
    |> String.split("\n")
    |> Enum.filter(&not_empty?/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  defp read_file do
    case File.read(@in) do
      {:ok, data} -> data
      {_, _error} -> IO.puts "error reading the file"
    end
  end

  defp not_empty?(string), do: String.length(string) > 0
end


