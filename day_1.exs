defmodule Day1 do
  @dial 50

  def run do
    read_from_file("input_day_1")
    |> parse_input(%{}, @dial)
    |> get_count()
  end

  defp read_from_file(filename) do
    file_path = Path.join(__DIR__, filename)

    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.to_list()
  end

  defp get_count(map) do
    max_count = map |> Map.values() |> Enum.max(fn -> 0 end)
  end

  defp parse_input([], map, dial), do: map

  defp parse_input([head | tail], map, dial) do
    rotations = head |> get_rotations_value() |> String.to_integer()
    delta = if String.starts_with?(head, "L"), do: -rotations, else: rotations
    new_dial = Integer.mod(dial + delta, 100)
    map = Map.update(map, new_dial, 1, fn count -> count + 1 end)

    parse_input(tail, map, new_dial)
  end

  defp get_rotations_value(<<"L", rest::binary>>), do: rest

  defp get_rotations_value(<<"R", rest::binary>>), do: rest
end
