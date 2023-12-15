defmodule MinecraftEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  ## Application behaviour
  
  @impl true
  def start(_type, _args) do
    children = [MinecraftEx.Endpoint]
    
    _ = maybe_generate_keys!()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MinecraftEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
  ## Private function
  
  defp maybe_generate_keys!() do
    priv = MinecraftEx.priv_key_file()
    pub = MinecraftEx.pub_key_file()
    
    if not File.exists?(priv) or not File.exists?(pub) do
      _ = generate_keys!()
    end
  end
  
  defp generate_keys!() do
    bits = 1024
    
    {:RSAPrivateKey, _, modulus, publicExponent, _, _, _, _, _, _, _} =
      rsa_private_key = :public_key.generate_key({:rsa, bits, 65537})

    rsa_public_key = {:RSAPublicKey, modulus, publicExponent}

    pem_entry = :public_key.pem_entry_encode(:RSAPrivateKey, rsa_private_key)
    private_key = :public_key.pem_encode([pem_entry])
    public_key = :ssh_file.encode([{rsa_public_key, []}], :openssh_key)

    _ = File.mkdir_p!(MinecraftEx.keys_root())
    _ = File.write!(MinecraftEx.pub_key_file(), public_key)
    _ = File.write!(MinecraftEx.priv_key_file(), private_key)
  end
end
