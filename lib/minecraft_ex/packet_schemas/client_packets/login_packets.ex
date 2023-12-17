defmodule MinecraftEx.Client.LoginPackets do
  @moduledoc """
  Documentation for MinecraftEx.Client.LoginPackets
  """

  use ElvenGard.Network.PacketSerializer

  import MinecraftEx, only: [has_state: 2]

  alias MinecraftEx.Types.{ByteArray, MCString, UUID}

  ## Login packets

  # 0x00 Login Start - state=login
  @deserializable true
  defpacket 0x00 when has_state(socket, :login), as: LoginStart do
    field :name, MCString
    field :player_uuid, UUID
  end

  # 0x01 Login Start - state=login
  @deserializable true
  defpacket 0x01 when has_state(socket, :login), as: EncryptionResponse do
    field :shared_secret, ByteArray, prefix: true, as: :binary
    field :verify_token, ByteArray, prefix: true, as: :binary
  end

  # 0x03 Login Acknowledged - state=login
  @deserializable true
  defpacket 0x03 when has_state(socket, :login), as: LoginAcknowledged
end
