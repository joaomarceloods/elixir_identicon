defmodule Identicons do
  def main(input) do
    input
    |> hash()
    |> pick_color()
  end

  defp hash(input) do
    hash = :crypto.hash(:md5, input)
    |> :binary.bin_to_list()

    %Identicons.Image{hex: hash}
  end

  defp pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _]} = image
    [r, g, b]
  end
end
