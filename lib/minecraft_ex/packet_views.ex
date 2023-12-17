defmodule MinecraftEx.PacketViews do
  @moduledoc """
  Documentation for MinecraftEx.PacketViews
  """

  use ElvenGard.Network.View

  alias MinecraftEx.Crypto
  alias MinecraftEx.Server.HandshakePackets.{PongResponse, StatusResponse}

  alias MinecraftEx.Server.LoginPackets.{
    EncryptionRequest,
    LoginSuccess,
    SetCompression
  }

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
    %EncryptionRequest{
      # Not required - default to ""
      server_id: "",
      public_key: Crypto.get_public_der(),
      verify_token: token
    }
  end

  @impl true
  def render(:login_success, %{uuid: uuid, username: username}) do
    %LoginSuccess{
      uuid: uuid,
      username: username,
      # FIXME: ????
      properties: []
    }
  end

  @impl true
  def render(:set_compression, %{threshold: threshold}) do
    %SetCompression{threshold: threshold}
  end
end
