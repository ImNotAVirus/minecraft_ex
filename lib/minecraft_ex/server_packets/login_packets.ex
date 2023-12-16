defmodule MinecraftEx.Server.LoginPackets do
  @moduledoc """
  Documentation for MinecraftEx.Server.LoginPackets
  """

  use ElvenGard.Network.PacketSerializer

  alias MinecraftEx.Types.{ByteArray, MCString}

  ## Login packets

  @serializable true
  defpacket 0x01, as: EncryptionRequest do
    field :server_id, MCString, default: ""
    field :public_key, ByteArray, prefix: true
    field :verify_token, ByteArray, prefix: true
  end
end
