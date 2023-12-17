defmodule MinecraftEx.Server.ConfigurationPackets do
  @moduledoc """
  Documentation for MinecraftEx.Server.ConfigurationPackets
  """

  use ElvenGard.Network.PacketSerializer

  ## Configuration packets

  # 0x02 Configuration
  @serializable true
  defpacket 0x02, as: FinishConfiguration
end
