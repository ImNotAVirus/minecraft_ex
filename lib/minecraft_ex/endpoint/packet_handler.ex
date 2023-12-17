defmodule MinecraftEx.Endpoint.PacketHandler do
  @moduledoc """
  Documentation for MinecraftEx.Endpoint.PacketHandler
  """

  require Logger

  ## Dynamic dispatcher
  def handle_packet(%struct{} = packet, socket) do
    case Module.split(struct) do
      ["MinecraftEx", "Client", "HandshakePackets" | _] ->
        MinecraftEx.PacketHandlers.Handshake.handle_packet(packet, socket)

      ["MinecraftEx", "Client", "LoginPackets" | _] ->
        MinecraftEx.PacketHandlers.Login.handle_packet(packet, socket)

      _ ->
        Logger.error("No handler found for #{inspect(packet)}")
    end
  end
end
