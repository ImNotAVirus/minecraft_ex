defmodule MinecraftEx.PacketHandlers.Configuration do
  @moduledoc """
  TODO: Documentation for MinecraftEx.PacketHandlers.Configuration
  """

  require Logger

  import ElvenGard.Network.Socket, only: [assign: 2]

  alias ElvenGard.Network.Socket

  alias MinecraftEx.Client.ConfigurationPackets.{
    ClientInformation,
    FinishConfiguration,
    PluginMessage
  }

  alias MinecraftEx.PacketViews

  ## Public API

  def handle_packet(%PluginMessage{channel: {"minecraft", "brand"}, data: "vanilla"}, socket) do
    {:cont, socket}
  end

  def handle_packet(%ClientInformation{} = info, socket) do
    Logger.info("Got info: #{inspect(info)}")
    {:cont, socket}
  end

  def handle_packet(%FinishConfiguration{}, socket) do
    info = %{entity_id: 123}
    render = PacketViews.render(:play_login, info)
    :ok = Socket.send(socket, render)

    {:cont, assign(socket, state: :play)}
  end
end
