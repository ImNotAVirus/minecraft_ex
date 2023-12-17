defmodule MinecraftEx.Client.ConfigurationPackets do
  @moduledoc """
  Documentation for MinecraftEx.Client.ConfigurationPackets
  """

  use ElvenGard.Network.PacketSerializer

  import MinecraftEx, only: [has_state: 2]

  alias MinecraftEx.Types.{
    Boolean,
    Byte,
    ByteArray,
    Enum,
    Identifier,
    MCString,
    VarInt
  }

  ## Configuration packets

  # 0x00 Client Information - state=configuration
  @deserializable true
  defpacket 0x00 when has_state(socket, :configuration), as: ClientInformation do
    field :locale, MCString
    field :view_distance, Byte
    field :chat_mode, Enum, from: VarInt, values: [enabled: 0, commands_only: 1, hidden: 2]
    field :chat_colors, Boolean
    field :displayed_skin_parts, Byte, sign: :unsigned
    field :main_hand, Enum, from: VarInt, values: [left: 0, right: 1]
    field :text_filtering, Boolean
    field :server_listings, Boolean
  end

  # 0x01 Plugin Message - state=configuration
  @deserializable true
  defpacket 0x01 when has_state(socket, :configuration), as: PluginMessage do
    field :channel, Identifier
    field :data, ByteArray, prefix: true, as: :binary
  end

  # 0x02 Finish Configuration - state=configuration
  @deserializable true
  defpacket 0x02 when has_state(socket, :configuration), as: FinishConfiguration
end
