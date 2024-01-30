defmodule Utils.Hashing do
  @moduledoc """
  A util helper to handle hashing values for security.
  """

  @spec to_sha256(String.t()) :: String.t()
  def to_sha256(<<string::binary>>) do
    :crypto.hash(:sha256, string) |> Base.encode16()
  end
end
