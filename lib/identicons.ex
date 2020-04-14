defmodule Identicons do
  def main(input) do
    input
    |> hash()
  end

  defp hash(input) do
    hash = :crypto.hash(:md5, input)
    |> :binary.bin_to_list()

    %Identicons.Image{hex: hash}
  end
end
