defmodule MinecraftEx.Types.UUID do
  @moduledoc """
  A UUID

  ===

  Encoded as an unsigned 128-bit integer (or two unsigned 64-bit integers: 
  the most significant 64 bits and then the least significant 64 bits) 
  """

  use ElvenGard.Network.Type

  @type t :: String.t()

  ## Behaviour impls

  @impl true
  @spec decode(bitstring, keyword) :: {t(), bitstring}
  def decode(data, _opts) when is_binary(data) do
    <<data::binary-16, rest::bitstring>> = data
    {ElvenGard.Network.UUID.uuid_to_string(data), rest}
  end

  @impl true
  @spec encode(t(), keyword) :: bitstring
  def encode(data, _opts) do
    # Get each parts
    <<
      a::binary-8,
      ?-,
      b::binary-4,
      ?-,
      c::binary-4,
      ?-,
      d::binary-4,
      ?-,
      e::binary-12
    >> = data

    # Regroup all parts
    full = <<a::binary, b::binary, c::binary, d::binary, e::binary>>

    # Transform to int
    int = String.to_integer(full, 16)

    # 128 bits repr
    <<int::unsigned-128>>
  end
end
