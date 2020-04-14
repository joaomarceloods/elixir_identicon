defmodule Identicon do
  def main(input) do
    input
    |> set_hash()
    |> set_color()
  end

  defp set_hash(input) do
    hash =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hash}
  end

  defp set_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image, color: {r, g, b}}
  end
end
