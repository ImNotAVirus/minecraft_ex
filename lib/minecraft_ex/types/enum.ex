defmodule MinecraftEx.Types.Enum do
  @moduledoc """
  A specific value from a given list

  ===

  The list of possible values and how each is encoded as an X must be known
  from the context. An invalid value sent by either side will usually result
  in the client being disconnected with an error or even crashing.
  """

  use ElvenGard.Network.Type

  @type t :: :atom

  ## Behaviour impls

  @impl true
  @spec decode(bitstring, keyword) :: {t(), bitstring}
  def decode(data, opts) when is_binary(data) do
    # Enum, from: VarInt, values: [status: 1, login: 2]
    # Enum, from: {VarInt, [opts]}, values: [status: 1, login: 2]
    enumerators = Keyword.fetch!(opts, :values)

    {value, rest} =
      case Keyword.get(opts, :from) do
        {from, from_opts} -> from.decode(data, from_opts)
        from -> from.decode(data, [])
      end

    {key, _v} = Enum.find(enumerators, &(elem(&1, 1) == value))
    {key, rest}
  end

  @impl true
  @spec encode(t(), keyword) :: bitstring
  def encode(data, opts) do
    # Enum, from: VarInt, values: [status: 1, login: 2]
    # Enum, from: {VarInt, [opts]}, values: [status: 1, login: 2]
    enumerators = Keyword.fetch!(opts, :values)
    value = Keyword.fetch!(enumerators, data)

    case Keyword.get(opts, :from) do
      {from, from_opts} -> from.encode(value, from_opts)
      from -> from.encode(value, [])
    end
  end
end
