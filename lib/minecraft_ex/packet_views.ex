defmodule MinecraftEx.PacketViews do
  @moduledoc """
  Documentation for MinecraftEx.PacketViews
  """

  use ElvenGard.Network.View

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
    # https://erlang-questions.erlang.narkive.com/r4yyaBxT/public-key-openssl-format-weirdness
    pub_key = File.read!(MinecraftEx.pub_key_file())
    [{pem_data, []}] = :ssh_file.decode(pub_key, :openssh_key)
    der_key = :public_key.der_encode(:RSAPublicKey, pem_data)
  
    %EncryptionRequest{
      public_key_length: byte_size(der_key),
      public_key: der_key,
      verify_token_length: byte_size(token),
      verify_token: token,
    }
  end
end
