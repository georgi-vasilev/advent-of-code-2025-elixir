defmodule Day1 do
  @dial 50
  @file_name "input_day_1"

  def run do
    read_from_file(@file_name)
    |> parse_input(0, @dial)
  end

  defp read_from_file(filename) do
    file_path = Path.join(__DIR__, filename)

    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.to_list()
  end

  defp parse_input([], passes, dial), do: passes

  defp parse_input([head | tail], passes, dial) do
    rotations = head |> get_rotations_value() |> String.to_integer()
    direction = if String.starts_with?(head, "L"), do: -1, else: 1

    dist_to_zero =
      if direction == 1 do
        if dial == 0, do: 100, else: 100 - dial
      else
        if dial == 0, do: 100, else: dial
      end

    new_passes =
      if rotations >= dist_to_zero do
        passes + 1 + trunc((rotations - dist_to_zero) / 100)
      else
        passes
      end

    new_dial = rem(rem(dial + direction * rotations, 100) + 100, 100)

    parse_input(tail, new_passes, new_dial)
  end

  defp zero_crosses(start, delta) do
    real_start = start
    real_end = start + delta

    start_block = div(real_start, 100)
    end_block = div(real_end, 100)

    abs(end_block - start_block)
  end

  defp get_rotations_value(<<"L", rest::binary>>), do: rest

  defp get_rotations_value(<<"R", rest::binary>>), do: rest
end

