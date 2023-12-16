defmodule MinecraftEx.Endpoint.PacketHandler do
  @moduledoc """
  Documentation for MinecraftEx.Endpoint.PacketHandler
  """

  import ElvenGard.Network.Socket, only: [assign: 2]

  require Logger
  alias ElvenGard.Network.Socket
  alias MinecraftEx.Resources

  alias MinecraftEx.Client.HandshakePackets.{
    Handshake,
    PingRequest,
    StatusRequest
  }

  alias MinecraftEx.Client.LoginPackets.{
    EncryptionResponse,
    LoginStart
  }

  alias MinecraftEx.Crypto
  alias MinecraftEx.PacketViews

  ## Handshake packets

  def handle_packet(%Handshake{} = packet, socket) do
    {:cont, assign(socket, state: packet.next_state)}
  end

  def handle_packet(%StatusRequest{}, socket) do
    render = PacketViews.render(:status_response, %{status: status_response()})
    :ok = Socket.send(socket, render)
    {:cont, socket}
  end

  def handle_packet(%PingRequest{payload: payload}, socket) do
    render = PacketViews.render(:pong_response, %{payload: payload})
    :ok = Socket.send(socket, render)
    {:halt, socket}
  end

  ## Login packets

  def handle_packet(%LoginStart{name: name, player_uuid: player_uuid}, socket) do
    Logger.info("#{name} is trying to login (uuid: #{player_uuid})")

    token = :crypto.strong_rand_bytes(4)
    render = PacketViews.render(:encryption_request, %{token: token})
    :ok = Socket.send(socket, render)

    {:cont, assign(socket, token: token)}
  end

  def handle_packet(
        %EncryptionResponse{shared_secret: secret, verify_token: verify_token},
        socket
      ) do
    token = socket.assigns.token

    case Crypto.decrypt(verify_token) do
      ^token ->
        {:cont, socket}

      _ ->
        {:halt, :invalid_token, socket}
    end
  end

  ## Default handler

  def handle_packet(packet, socket) do
    IO.warn("no handler for #{inspect(packet)}")
    {:halt, socket}
  end

  ## Private functions

  defp status_response() do
    %{
      version: %{
        name: "1.20.4-ex",
        protocol: 765
      },
      players: %{
        max: 100,
        online: 1,
        sample: [
          %{
            name: "DarkyZ",
            id: "4566e69f-c907-48ee-8d71-d7ba5aa00d20"
          }
        ]
      },
      description: [
        %{text: "Hello from "},
        %{
          text: "Elixir",
          color: "dark_purple"
        },
        %{text: "!\n"},
        %{
          text: "ElixirElixirElixirElixirElixirElixirElixir",
          obfuscated: true
        }
      ],
      favicon: Resources.favicon(),
      enforcesSecureChat: true,
      previewsChat: true
    }
  end
end
