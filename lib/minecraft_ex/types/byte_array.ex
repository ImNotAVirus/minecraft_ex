defmodule MinecraftEx.Types.ByteArray do
  @moduledoc """
  Depends on context

  ===

  This is just a sequence of zero or more bytes, its meaning should be 
  explained somewhere else, e.g. in the packet description. The length 
  must also be known from the context. 
  """

  use ElvenGard.Network.Type

  @type t :: [byte()]

  ## Behaviour impls

  @impl true
  @spec decode(bitstring, keyword) :: {t(), bitstring}
  def decode(data, _opts) when is_binary(data) do
    raise "unsupported yet"
  end

  @impl true
  @spec encode(t() | binary(), keyword) :: bitstring
  def encode(data, _opts) when is_binary(data) do
    data
  end
  
  def encode(data, _opts) when is_list(data) do
    List.to_string(data)
  end
end
