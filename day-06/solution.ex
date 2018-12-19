defmodule Solution do
  def solve(input_file) do
    coords = data(input_file)
             |> create_pairs()

    labeled_coords = label_coords(coords)


    loaded_grid = coords
    |> create_empty_grid()
    |> fill_in_map(labeled_coords)

    areas = loaded_grid
            |> get_areas()

    excludes = get_infinite_areas(loaded_grid)

    get_finite_areas(areas, excludes)
    |> Enum.sort(fn ({k, v}, {k2, v2}) ->
      v >= v2
    end)
  end


  def bonus(input_file) do
    coords = data(input_file)
             |> create_pairs()

    labeled_coords = label_coords(coords)

    loaded_grid = coords
                  |> create_empty_grid()
                  |> fill_in_distances(coords)
                  |> count_in_area(10000)
  end

  def count_in_area(distances, cutoff) do
    Enum.reduce(distances, 0, fn (row, c) ->
      Enum.reduce(row, c, fn (cell, count) ->
        case String.to_integer(cell) < cutoff do
          true -> count + 1
          false -> count
        end
      end)
    end)
  end

  def fill_in_distances(grid, coords) do
    Enum.map(grid, fn row ->
      Enum.map(row, fn cell ->
        distance_to_all_coords(cell, coords)
        |> Integer.to_string
      end)
    end)
  end

  def distance_to_all_coords(cell, coords) do
    coords 
    |> Enum.reduce(0, fn (coord, distance) ->
      distance + manhattan_distance(cell, coord)
    end)
  end

  def get_finite_areas(areas, excludes) do
    Enum.filter(areas, fn {key, count} ->
      Enum.any?(excludes, &(&1 == key)) == false
    end)
  end

  def get_infinite_areas(loaded_grid) do
    exclude = List.first(loaded_grid) ++ List.last(loaded_grid)
    Enum.reduce(loaded_grid, exclude, fn x, acc ->
      [List.first(x), List.last(x) | acc] 
    end)
    |> Enum.uniq
  end

  def get_areas(loaded_grid) do
    Enum.reduce(loaded_grid, %{}, fn (row, acc) ->
      Enum.reduce(row, acc, fn (cell, bcc) ->
        Map.update(
          bcc,
          cell,
          1,
          &(&1 + 1)
        )
      end)
    end)
  end

  def fill_in_map(grid, labeled_coords) do
    Enum.map(grid, fn row ->
      Enum.map(row, fn cell ->
        find_closest_coord(cell, labeled_coords)
      end)
    end)
  end

  def find_closest_coord(cell, labeled_coords) do
    labeled_coords
    |> Enum.reduce({-1, 100_000}, fn ({coord, label}, {min_label, min_distance}) ->
      md = manhattan_distance(cell, coord)
      cond do
        # md == 0 -> {String.upcase(label), md}
        md == min_distance -> {'.', md}
        md < min_distance -> {label, md}
        true -> {min_label, min_distance}
      end
    end)
    |> elem(0)
  end

  def manhattan_distance({cellx, celly}, {coordx, coordy}) do
    abs(cellx - coordx) + abs(celly - coordy)
  end

  def label_coords(coords) do
    coords
    |> Stream.with_index()
    # |> Enum.map(fn ({coord, label}) ->
    #   {coord, <<(label + 97)::utf8>>}
    # end)
  end

  def create_empty_grid(pairs) do
    {max_x, max_y} = Enum.reduce(pairs, {0, 0}, fn {x, y}, {max_x, max_y} ->
      max_x = case x > max_x do
        true -> x
        false -> max_x
      end

      max_y = case y > max_y do
        true -> y
        false -> max_y
      end

      {max_x, max_y}
    end)

    Enum.map(1..max_y + 2, fn y ->
      Enum.map(1..max_x + 2, fn x ->
        {x - 1, y - 1}
      end)
    end)
  end

  def create_pairs(rows) do
    Enum.map(rows, fn row ->
      coords = String.split(row, ", ")
               |> Enum.map(&String.to_integer/1)
      {List.first(coords), List.last(coords)}
    end)
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
