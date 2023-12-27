defmodule Wtrmln.Message do
  use Ecto.Schema

  schema "messages" do
    field :username, :string
    field :message, :string
    belongs_to :room, Wtrmln.Room

    timestamps(type: :utc_datetime)
  end
end
