defmodule MinecraftEx.Types.Position do
  @moduledoc """
  An integer/block position: x (-33554432 to 33554431), z (-33554432 
  to 33554431), y (-2048 to 2047)

  ===

  x as a 26-bit integer, followed by z as a 26-bit integer, followed by 
  y as a 12-bit integer (all signed, two's complement)
  """

  use ElvenGard.Network.Type

  @type x :: -33_554_432..33_554_431
  @type y :: -2048..2047
  @type z :: -33_554_432..33_554_431
  @type t :: {x(), y(), z()}

  ## Behaviour impls

  @impl true
  @spec decode(bitstring, keyword) :: {t(), bitstring}
  def decode(data, _opts) when is_binary(data) do
    <<x::signed-26, z::signed-26, y::signed-12, rest::bitstring>> = data
    {{x, y, z}, rest}
  end

  @impl true
  @spec encode(t(), keyword) :: bitstring
  def encode({x, y, z}, _opts) do
    <<x::signed-26, z::signed-26, y::signed-12>>
  end
end
