defmodule MinecraftEx.Types.Identifier do
  @moduledoc """
  Encoded as a String with max length of 32767.

  ===

  Identifiers are a namespaced location, in the form of minecraft:thing. 
  If the namespace is not provided, it defaults to minecraft 
  (i.e. thing is minecraft:thing).

  Custom content should always be in its own namespace, not the default one. 
  Both the namespace and value can use all lowercase alphanumeric characters
   (a-z and 0-9), dot (.), dash (-), and underscore (_).
   In addition, values can use slash (/). The naming convention is 
   lower_case_with_underscores. More information. For ease of determining 
   whether a namespace or value is valid, here are regular expressions for each:

      Namespace: [a-z0-9.-_]
      Value: [a-z0-9.-_/]

  """

  use ElvenGard.Network.Type

  alias MinecraftEx.Types.MCString

  @type namespace :: String.t()
  @type value :: String.t()
  @type t :: {namespace(), value()}

  ## Behaviour impls

  @impl true
  @spec decode(bitstring, keyword) :: {t(), bitstring}
  def decode(data, _opts) when is_binary(data) do
    {string, rest} = MCString.decode(data)

    case String.split(string, ":", trim: true) do
      [value] -> {{"minecraft", value}, rest}
      [namespace, value] -> {{namespace, value}, rest}
    end
  end

  @impl true
  @spec encode(t(), keyword) :: bitstring
  def encode({namespace, value}, _opts) do
    MCString.encode("#{namespace}:#{value}")
  end

  def encode(value, _opts) when is_binary(value) do
    MCString.encode("minecraft:#{value}")
  end
end
