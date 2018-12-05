defmodule Solution do
  def solve(input_file) do
    data(input_file)
    |> List.first()
    |> String.graphemes()
    # |> split_polymers()
    |> check_pairs([])
    |> Enum.count()
  end

  def split_polymers([a, b]) do
    check_pairs([a, b], [])
  end

  def split_polymers([a]) do
    [a]
  end

  def split_polymers(polymers) do
    c = Enum.count(polymers) |> div(2)
    {first, second} = polymers
                      |> Enum.split(c)
    a = split_polymers(first) |> check_pairs([])
    b = split_polymers(second) |> check_pairs([])

    List.flatten(a, b)
  end

  def check_pairs([], processed), do: Enum.reverse(processed)

  def check_pairs([a], processed), do: check_pairs([], [a | processed])

  def check_pairs([a, b | tail], processed) do
    case reactive_pair?(a, b) do
      true -> check_pairs(Enum.reverse(tail) ++ processed, [])
      false -> check_pairs([b | tail], [a | processed])
    end
  end

  def reactive_pair?(a, b) do
    <<aa::utf8>> = a
    <<bb::utf8>> = b
    abs(aa - bb) == 32
  end

  def data(input_file) do
    read_file(input_file)
    |> String.split("\n")
    |> Enum.filter(&not_empty?/1)
  end

  defp read_file(input_file) do
    case File.read(input_file) do
      {:ok, data} -> data
      {_, _error} -> IO.puts "error reading the file"
    end
  end

  defp not_empty?(string), do: String.length(string) > 0
end
