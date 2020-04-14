defmodule Identicon do
  def main(input) do
    input
    |> hash()
    |> pick_color()
  end

  defp hash(input) do
    hash =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hash}
  end

  defp pick_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image, color: {r, g, b}}
  end
end
