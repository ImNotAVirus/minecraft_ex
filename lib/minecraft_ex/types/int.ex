defmodule MinecraftEx.Types.Int do
  @moduledoc """
  Signed 32-bit integer, two's complement 

  ===

  An integer between -2147483648 and 2147483647
  """

  use ElvenGard.Network.Type

  @type t :: -2_147_483_648..2_147_483_647

  ## Behaviour impls

  @impl true
  @spec decode(bitstring, keyword) :: {t(), bitstring}
  def decode(data, _opts) when is_binary(data) do
    <<value::signed-32, rest::bitstring>> = data
    {value, rest}
  end

  @impl true
  @spec encode(t(), keyword) :: bitstring
  def encode(data, _opts) when is_integer(data) do
    <<data::signed-32>>
  end
end
