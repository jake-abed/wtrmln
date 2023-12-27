defmodule Wtrmln.Message do
  use Ecto.Schema

  schema "message" do
    field :username, :string
    field :message, :string
    belongs_to :room, Wtrmln.Room

    timestamp(type: :utc_datetime)
  end
end
