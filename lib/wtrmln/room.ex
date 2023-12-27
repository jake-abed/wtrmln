defmodule Wtrmln.Room do
  use Ecto.Schema

  schema "room" do
    field :seed, :string
    has_many :messages, Wtrmln.Message
  end
end
