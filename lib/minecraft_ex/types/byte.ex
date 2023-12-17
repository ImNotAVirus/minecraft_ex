defmodule MinecraftEx.Types.Byte do
  @moduledoc """
  Signed/Unsigned 8-bit integer 

  ===

  An integer between -128 and 127 or 0 and 255
  """

  use ElvenGard.Network.Type

  @type t :: -128..127 | 0..255

  ## Behaviour impls

  @impl true
  @spec decode(bitstring, keyword) :: {t(), bitstring}
  def decode(data, opts) when is_binary(data) do
    case Keyword.get(opts, :sign, :signed) do
      :signed ->
        <<value::signed-8, rest::bitstring>> = data
        {value, rest}

      :unsigned ->
        <<value::unsigned-8, rest::bitstring>> = data
        {value, rest}
    end
  end

  @impl true
  @spec encode(t(), keyword) :: bitstring
  def encode(data, opts) when is_integer(data) do
    case Keyword.get(opts, :sign, :signed) do
      :signed -> <<data::signed-8>>
      :unsigned -> <<data::unsigned-8>>
    end
  end
end
