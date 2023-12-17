defmodule MinecraftEx.Server.LoginPackets do
  @moduledoc """
  Documentation for MinecraftEx.Server.LoginPackets
  """

  use ElvenGard.Network.PacketSerializer

  alias MinecraftEx.Types.{
    ByteArray,
    MCString,
    PropertyArray,
    UUID,
    VarInt
  }

  ## Login packets

  @serializable true
  defpacket 0x01, as: EncryptionRequest do
    field :server_id, MCString, default: ""
    field :public_key, ByteArray, prefix: true
    field :verify_token, ByteArray, prefix: true
  end

  @serializable true
  defpacket 0x02, as: LoginSuccess do
    field :uuid, UUID
    field :username, MCString
    field :properties, PropertyArray
  end

  @serializable true
  defpacket 0x03, as: SetCompression do
    field :threshold, VarInt
  end
end
