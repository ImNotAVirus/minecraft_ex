defmodule MinecraftEx.Mojang do
  @doc """
  TODO: Documentation for MinecraftEx.Mojang
  """

  alias MinecraftEx.Crypto

  ## Public API

  @spec verify_session(String.t(), String.t()) :: {:ok, map()} | {:error, :invalid_session}
  def verify_session(username, secret) do
    server_id = ""
    public_key = Crypto.get_public_der()
    login_hash = Crypto.sha1(server_id <> secret <> public_key)

    url = 'https://sessionserver.mojang.com/session/minecraft/hasJoined'
    qs = URI.encode_query(%{username: username, serverId: login_hash})
    full_url = '#{url}?#{qs}'
    headers = [{'accept', 'application/json'}]

    http_request_opts = [
      ssl: [
        verify: :verify_peer,
        cacerts: :public_key.cacerts_get(),
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ]
      ]
    ]

    case :httpc.request(:get, {full_url, headers}, http_request_opts, []) do
      {:ok, {{_, 200, _}, _, body}} -> {:ok, Poison.decode!(body)}
      _ -> {:error, :invalid_session}
    end
  end
end
