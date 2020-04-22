require Integer

defmodule Identicon do
  def main(input) do
    input
    |> set_hash()
    |> set_color()
    |> set_grid()
    |> create_image(input)
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
          |> Enum.filter(&is_even_code/1)
          |> Enum.map(&index_to_coordinate/1)
    }
  end

  defp mirror_row([a, b, c]) do
    [a, b, c, b, a]
  end

  defp is_even_code({code, _index}) do
    rem(code, 2) == 0
  end

  defp index_to_coordinate({_code, index}) do
    size = 50
    x = rem(index, 5) * size
    y = div(index, 5) * size
    top_left = {x, y}
    bottom_right = {x + size, y + size}
    {top_left, bottom_right}
  end

  defp create_image(%Identicon.Image{color: color, grid: grid}, filename) do
    image = :egd.create(250, 250)
    color = :egd.color(color)
    Enum.map grid, fn {top_left, bottom_right} ->
      :egd.filledRectangle(image, top_left, bottom_right, color)
    end
    :egd.render(image)
    |> :egd.save("#{filename}.png")
  end
end
