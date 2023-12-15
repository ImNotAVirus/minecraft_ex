defmodule MinecraftEx.Server.LoginPackets do
  @moduledoc """
  Documentation for MinecraftEx.Server.LoginPackets
  """

  use ElvenGard.Network.PacketSerializer

  alias MinecraftEx.Types.{ByteArray, VarInt, MCString}

  ## Login packets

  @serializable true
  defpacket 0x01, as: EncryptionRequest do
    field :server_id, MCString, default: ""
    field :public_key_length, VarInt
    field :public_key, ByteArray
    field :verify_token_length, VarInt
    field :verify_token, ByteArray
  end
end
