defmodule MinecraftEx.Types.PropertyArray do
  @moduledoc """
  Zero or more fields of type Property

  ===

  The count must be known from the context. 
  """

  use ElvenGard.Network.Type

  alias MinecraftEx.Types.VarInt

  @type t :: [any()]

  ## Behaviour impls

  @impl true
  @spec decode(bitstring(), Keyword.t()) :: {t(), bitstring()}
  def decode(data, _opts) when is_binary(data) do
    raise "unsupported yet"
  end

  @impl true
  @spec encode(t(), Keyword.t()) :: bitstring()
  def encode(data, _opts) when is_list(data) do
    if data != [], do: raise("unsupported yet")

    length = data |> length() |> VarInt.encode([])
    <<length::binary>>
  end
end
