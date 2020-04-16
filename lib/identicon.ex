defmodule Identicon do
  def main(input) do
    input
    |> set_hash()
    |> set_color()
    |> set_grid()
  end

  defp set_hash(input) do
    %Identicon.Image{
      hex:
        :crypto.hash(:md5, input)
        |> :binary.bin_to_list()
    }
  end

  defp set_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  defp set_grid(%Identicon.Image{hex: hex} = image) do
    %Identicon.Image{
      image
      | grid:
          hex
          |> hex_to_grid()
          |> boolean_grid()
          |> mirror_rows()
    }
  end

  defp hex_to_grid(hex) do
    Enum.chunk_every(hex, 3, 3, :discard)
  end

  defp boolean_grid(grid) do
    Enum.map(grid, fn row -> row_to_boolean(row) end)
  end

  defp row_to_boolean(row) do
    Enum.map(row, fn i -> Kernel.trunc(i) |> Kernel.rem(2) end)
  end

  defp mirror_rows(grid) do
    Enum.map(grid, fn [a, b, c] -> [a, b, c, b, a] end)
  end
end
