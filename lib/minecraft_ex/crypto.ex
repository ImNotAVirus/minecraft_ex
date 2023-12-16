defmodule MinecraftEx.Crypto do
  @moduledoc """
  TODO: Documentation for MinecraftEx.Crypto
  """

  @bits 1024

  ## Public API

  @spec setup!() :: :ok
  def setup!() do
    # Generate new keys
    {pub_der, priv_pem} = generate_keys()

    # Use persistent_term as storage
    :ok = :persistent_term.put(pub_der(), pub_der)
    :ok = :persistent_term.put(priv_pem(), priv_pem)

    :ok
  end

  def get_public_der() do
    :persistent_term.get(pub_der())
  end

  def decrypt(message) do
    priv_key = :persistent_term.get(priv_pem())
    :public_key.decrypt_private(message, priv_key)
  end

  ## Private Helpers

  defp pub_der(), do: :public_key_der
  defp priv_pem(), do: :private_key_pem

  defp generate_keys() do
    # Generate Private Key (PEM)
    {:RSAPrivateKey, _, modulus, publicExponent, _, _, _, _, _, _, _} =
      rsa_private_key = :public_key.generate_key({:rsa, @bits, 65537})

    # priv_pem_entry = :public_key.pem_entry_encode(:RSAPrivateKey, rsa_private_key)
    # private_key = :public_key.pem_encode([priv_pem_entry])

    # Generate Public Key (PEM)
    rsa_public_key = {:RSAPublicKey, modulus, publicExponent}
    # pub_pem_entry = :public_key.pem_entry_encode(:RSAPublicKey, rsa_public_key)
    # public_key = :public_key.pem_encode([pub_pem_entry])

    # Generate Public (ASN.1 DER)
    {:SubjectPublicKeyInfo, public_der, _} =
      :public_key.pem_entry_encode(:SubjectPublicKeyInfo, rsa_public_key)

    {public_der, rsa_private_key}
  end
end
