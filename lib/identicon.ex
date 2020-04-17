require Integer

defmodule Identicon do
  def main(input) do
    input
    |> set_hash()
    |> set_color()
    |> set_grid()
  end

  defp set_hash(input) do
    %Identicon.Image{
      hash:
        :crypto.hash(:md5, input)
        |> :binary.bin_to_list()
    }
  end

  defp set_color(%Identicon.Image{hash: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  defp set_grid(%Identicon.Image{hash: hash} = image) do
    %Identicon.Image{
      image
      | grid:
          hash
          |> Enum.chunk_every(3, 3, :discard)
          |> Enum.map(&mirror_row/1)
          |> List.flatten()
          |> Enum.with_index()
          |> Enum.filter(&is_even/1)
    }
  end

  defp mirror_row([a, b, c]) do
    [a, b, c, b, a]
  end

  defp is_even({code, _index}) do
    rem(code, 2) == 0
  end
end
