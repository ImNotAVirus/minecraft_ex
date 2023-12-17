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

  @spec get_public_der() :: binary()
  def get_public_der() do
    :persistent_term.get(pub_der())
  end

  @spec decrypt(binary()) :: binary()
  def decrypt(message) do
    priv_key = :persistent_term.get(priv_pem())
    :public_key.decrypt_private(message, priv_key)
  end

  @doc """
  Note that the sha1() method used by minecraft is non standard.
  It doesn't match the digest method found in most programming languages and libraries.

  It works by treating the sha1 output bytes as one large integer in two's complement 
  and then printing the integer in base 16, placing a minus sign if the interpreted 
  number is negative.

  Some examples of the minecraft digest are found below:

    sha1(Notch) :  4ed1f46bbe04bc756bcb17c0c7ce3e4632f06a48
    sha1(jeb_)  : -7c9d5b0044c130109a5d7b5fb5c317c02b4e28c1
    sha1(simon) :  88e16a1019277b15d58faf0541e11910eb756f6
  """
  @spec sha1(binary()) :: binary()
  def sha1(value) do
    case :crypto.hash(:sha, value) do
      <<hash::signed-integer-160>> when hash < 0 ->
        "-" <> String.downcase(Integer.to_string(-hash, 16))

      <<hash::signed-integer-160>> ->
        String.downcase(Integer.to_string(hash, 16))
    end
  end

  def aes_encrypt(data, key, iv) do
    do_aes(data, key, iv, true)
  end

  def aes_decrypt(data, key, iv) do
    do_aes(data, key, iv, false)
  end

  ## Private Helpers

  defp pub_der(), do: :public_key_der
  defp priv_pem(), do: :private_key_pem

  defp generate_keys() do
    # Generate Private Key (PEM)
    {:RSAPrivateKey, _, modulus, publicExponent, _, _, _, _, _, _, _} =
      rsa_private_key = :public_key.generate_key({:rsa, @bits, 65537})

    # Generate Public (ASN.1 DER)
    rsa_public_key = {:RSAPublicKey, modulus, publicExponent}

    {:SubjectPublicKeyInfo, public_der, _} =
      :public_key.pem_entry_encode(:SubjectPublicKeyInfo, rsa_public_key)

    {public_der, rsa_private_key}
  end

  defp do_aes(data, key, iv, is_encryption) do
    cipher = :crypto.crypto_one_time(:aes_cfb8, key, iv, data, is_encryption)

    # iv_size = byte_size(iv)
    iv_size = 16

    full_data =
      case {byte_size(cipher) >= iv_size, is_encryption} do
        {true, true} -> cipher
        {true, false} -> data
        {false, true} -> <<iv::binary, cipher::binary>>
        {false, false} -> <<iv::binary, data::binary>>
      end

    offset = byte_size(full_data) - iv_size
    new_iv = :binary.part(full_data, offset, iv_size)

    {cipher, new_iv}
  end
end
