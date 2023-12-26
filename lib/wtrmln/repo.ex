defmodule Wtrmln.Repo do
  use Ecto.Repo,
    otp_app: :wtrmln,
    adapter: Ecto.Adapters.Postgres
end
