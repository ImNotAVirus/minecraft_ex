defmodule MinecraftEx do
  @moduledoc """
  Documentation for `MinecraftEx`.
  """

  defguard has_state(socket, state) when socket.assigns.state == state

  def keys_root(), do: Path.join(File.cwd!(), "data")
  def priv_key_file(), do: Path.join(keys_root(), "id_rsa")
  def pub_key_file(), do: Path.join(keys_root(), "id_rsa.pub")
end
