defmodule Solution do

  def solve(input_file) do
    data(input_file)
    |> sort_log_entries()
    |> sleeping_minutes(nil, nil, %{})
    |> laziest_elf()
    |> sleepiest_minute()
    |> get_elf_product()
  end

  def bonus(input_file) do
    data(input_file)
    |> sort_log_entries()
    |> sleeping_minutes(nil, nil, %{})
    |> consistent_sleeper()
    |> get_consistent_sleeper_product
  end

  def get_consistent_sleeper_product({guard_id, _count, minute}), do: guard_id * minute

  def consistent_sleeper(minutes) do
    minutes
    |> Enum.reduce({0, 0, 0}, fn ({{gid, m}, c}, {agid, ac, am}) ->
      case c > ac do
        true -> {gid, c, m}
        false -> {agid, ac, am}
      end
    end)
  end

  def get_elf_product({guard_number, sleepiest_minute}), do: guard_number * sleepiest_minute

  def sleepiest_minute({guard_number, minutes}) do
    m = Enum.filter(minutes, fn ({{g_id, _m}, _c}) -> g_id == guard_number end)
        |> Enum.reduce({0, 0}, fn ({{_g_id, m}, c}, {am, ac}) ->
          case c > ac do
            true -> {m, c}
            false -> {am, ac} 
          end
        end)
        |> elem(0)
    {guard_number, m}
  end

  def laziest_elf(minutes) do
    guard_number = Enum.reduce(minutes, %{}, fn ({{guard_number, minute}, count}, acc) ->
      Map.update(
        acc,
        guard_number,
        count, 
        &(&1 + count)
      )
    end)
    |> Map.to_list
    |> Enum.sort(fn ({_ida, ca}, {_idb, cb}) -> ca > cb end)
    |> List.first()
    |> elem(0)

    {guard_number, minutes}
  end

  def sleeping_minutes([], _guard_number, _sleep_start, sleep), do: sleep

  def sleeping_minutes([%{:status => :shift_change} = log | tail], _guard_number, _sleep_start, sleep) do
    sleeping_minutes(tail, log.guard_number, nil, sleep)
  end

  def sleeping_minutes([%{:status => :falls_asleep} = log | tail], guard_number, sleep_start, sleep) do
    sleeping_minutes(tail, guard_number, log.minute, sleep)
  end

  def sleeping_minutes([%{:status => :wakes_up} = log | tail], guard_number, sleep_start, sleep) do
    sleeping_minutes(
      tail,
      guard_number,
      nil,
      Enum.reduce(sleep_start..(log.minute - 1), sleep,
        fn x, acc ->
          Map.update(
            acc,
            {guard_number, x},
            1,
            &(&1 + 1)
          )
        end)
    )
  end

  def sort_log_entries(logs) do
    logs
    |> Enum.map(&to_date/1)
    |> Enum.sort(&(&1[:datetime] <= &2[:datetime]))
    |> Enum.sort(fn (%{:datetime => d1}, %{:datetime => d2}) ->
      case NaiveDateTime.compare(d1, d2) do
        :lt -> true
        :eq -> true
        :gt -> false
      end
    end)
  end

  def to_date(log) do
    date_parts = String.split(log, ["[", "]", " ", "-", ":"])
    tc = take_and_convert(date_parts)
    message = Enum.split(date_parts, 7) |> elem(1) |> Enum.join(" ")
    %{ 
      datetime:
        %NaiveDateTime{
          year: tc.(1),
          month: tc.(2),
          day: tc.(3),
          hour: tc.(4),
          minute: tc.(5),
          second: 0,
        },
      status: get_status(message),
      minute: tc.(5),
      guard_number: get_guard_number(message)
    }
  end

  def get_guard_number(message) do
    case String.contains?(message, "Guard") do
      true ->
        String.split(message, ["#", " "])
        |> Enum.at(2)
        |> String.to_integer()
      false -> nil
    end
  end

  def get_status(message) do
    cond do
      String.contains?(message, "Guard") ->
        :shift_change
      String.contains?(message, "falls asleep") ->
        :falls_asleep
      String.contains?(message, "wakes up") ->
        :wakes_up
    end
  end

  def take_and_convert(date_strings) do
    fn pos ->
      date_strings
      |> Enum.at(pos)
      |> String.to_integer
    end
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
