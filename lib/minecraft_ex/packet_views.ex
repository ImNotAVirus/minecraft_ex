defmodule MinecraftEx.PacketViews do
  @moduledoc """
  Documentation for MinecraftEx.PacketViews
  """

  use ElvenGard.Network.View

  alias MinecraftEx.Crypto
  alias MinecraftEx.Server.HandshakePackets.{PongResponse, StatusResponse}
  alias MinecraftEx.Server.LoginPackets.{EncryptionRequest}

  ## Handshake views

  @impl true
  def render(:status_response, %{status: status}) do
    %StatusResponse{json: Poison.encode!(status)}
  end

  @impl true
  def render(:pong_response, %{payload: payload}) do
    %PongResponse{payload: payload}
  end

  ## Login views

  @impl true
  def render(:encryption_request, %{token: token}) do
    der_key = Crypto.get_public_der()

    %EncryptionRequest{
      # Not required
      server_id: "",
      public_key: der_key,
      verify_token: token,
    }
  end
end
