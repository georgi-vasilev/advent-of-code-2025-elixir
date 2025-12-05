defmodule Day2 do
  @file_name "input_day_2"

  def run do
    @file_name
    |> read_from_file()
    |> parse_input()
  end

  defp read_from_file(filename) do
    file_path = Path.join(__DIR__, filename)

    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.to_list()
  end

  defp parse_input([line]) do
    line
    |> String.split(",")
    |> Enum.reduce(0, fn curr, acc ->
      [first, second] = String.split(curr, "-")
      acc + get_invalid_ids_in_range(String.to_integer(first), String.to_integer(second))
    end)
  end

  defp get_invalid_ids_in_range(start, stop) do
    Enum.reduce(start..stop, 0, fn n, sum ->
      if repeating_characters?(n), do: sum + n, else: sum
    end)
  end

  defp repeating_middle?(num) do
    s = Integer.to_string(num)
    len = String.length(s)

    if rem(len, 2) != 0 do
      false
    else
      mid = div(len, 2)
      String.slice(s, 0, mid) == String.slice(s, mid, mid)
    end
  end

  defp repeating_characters?(num) do
    s = Integer.to_string(num)
    len = String.length(s)

    if len < 2 do
      false
    else
      Enum.any?(1..(len - 1), fn i ->
        if rem(len, i) == 0 do
          substr = String.slice(s, 0, i)
          repeat_count = div(len, i)
          String.duplicate(substr, repeat_count) == s
        else
          false
        end
      end)
    end
  end
end
