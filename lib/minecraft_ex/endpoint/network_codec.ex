defmodule MinecraftEx.Endpoint.NetworkCodec do
  @moduledoc """
  Documentation for MinecraftEx.Endpoint.NetworkCodec
  """

  @behaviour ElvenGard.Network.NetworkCodec

  alias MinecraftEx.Crypto
  alias MinecraftEx.ClientPackets
  alias MinecraftEx.Types.VarInt

  @impl true
  def next(<<>>, _socket), do: {nil, <<>>}

  def next(message, %{assigns: assigns}) do
    data = maybe_decrypt(message, assigns[:enc_key])

    {length, rest} = VarInt.decode(data)

    case byte_size(rest) == length do
      true -> {rest, ""}
      false -> raise "unsupported yet (need to check enc and manage iv)"
    end
  end

  @impl true
  def decode(raw, socket) do
    {packet_id, rest} = VarInt.decode(raw)
    ClientPackets.deserialize(packet_id, rest, socket)
  end

  @impl true
  def encode(struct, socket) when is_struct(struct) do
    {packet_id, params} = struct.__struct__.serialize(struct)
    encode([VarInt.encode(packet_id), params], socket)
  end

  def encode(raw, %{assigns: assigns}) when is_list(raw) do
    bin = :erlang.iolist_to_binary(raw)
    packet_length = bin |> byte_size() |> VarInt.encode([])
    result = [<<packet_length::binary>>, bin]

    maybe_encrypt(result, assigns[:enc_key])
  end

  ## Private functions

  # For the Initial Vector (IV) and AES setup, both sides use the shared 
  # secret as both the IV and the key.
  #
  # Note that the AES cipher is updated continuously, not finished and 
  # restarted every packet. 
  defp maybe_encrypt(data, enc_key) do
    crypto_state = Process.get(:enc_crypto_state)

    case {crypto_state, enc_key} do
      {{key, iv}, _} ->
        {cipher, new_iv} = Crypto.aes_encrypt(data, key, iv)
        _ = Process.put(:enc_crypto_state, {key, new_iv})
        cipher

      {_, key} when is_binary(key) ->
        {cipher, new_iv} = Crypto.aes_encrypt(data, key, key)
        _ = Process.put(:enc_crypto_state, {key, new_iv})
        cipher

      _ ->
        data
    end
  end

  defp maybe_decrypt(data, enc_key) do
    crypto_state = Process.get(:dec_crypto_state)

    case {crypto_state, enc_key} do
      {{key, iv}, _} ->
        {cipher, new_iv} = Crypto.aes_decrypt(data, key, iv)
        _ = Process.put(:dec_crypto_state, {key, new_iv})
        cipher

      {_, key} when is_binary(key) ->
        {cipher, new_iv} = Crypto.aes_decrypt(data, key, key)
        _ = Process.put(:dec_crypto_state, {key, new_iv})
        cipher

      _ ->
        data
    end
  end
end
