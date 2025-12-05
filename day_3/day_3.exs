defmodule Day3 do
  @file_name "input_day_3"

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

  defp parse_input(input) do
    input
    |> Enum.reduce(0, fn str, acc ->
      acc + find_biggest_12_digit_joltage(str)
    end)
  end

  defp find_biggest_joltage(str) do
    digits =
      str
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reverse()

    initial_state = {0, -1}

    {max, _} =
      Enum.reduce(digits, initial_state, fn digit, {max_pair, best_right} ->
        new_max =
          if best_right != -1 do
            max(max_pair, digit * 10 + best_right)
          else
            max_pair
          end

        new_best_right = max(best_right, digit)

        {new_max, new_best_right}
      end)

    max
  end

  defp max_n_digits(str, keep) do
    to_remove = String.length(str) - keep
    chars = str |> String.graphemes()

    {final_stack, _} =
      Enum.reduce(chars, {[], to_remove}, fn ch, {stack, removals_remaining} ->
        {new_stack, new_removals} =
          remove_smaller(ch, stack, removals_remaining)

        {[ch | new_stack], new_removals}
      end)

    final_stack
    |> Enum.reverse()
    |> Enum.take(keep)
    |> Enum.join("")
  end

  defp remove_smaller(ch, stack = [top | rest], removals_remaining)
       when removals_remaining > 0 and top < ch do
    remove_smaller(ch, rest, removals_remaining - 1)
  end

  defp remove_smaller(_ch, stack, removals_remaining) do
    {stack, removals_remaining}
  end

  defp find_biggest_12_digit_joltage(str) do
    max_n_digits(str, 12)
    |> String.to_integer()
  end
end
