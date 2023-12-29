defmodule Wtrmln.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :username, :string
    field :message, :string
    belongs_to :room, Wtrmln.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:username, :message, :room_id])
    |> validate_required([:username, :message])
  end

  @type message()
    :: %{seed: String.t(), message: String.t(), username: String.t()}
  @spec add_message(message())
    :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def add_message(message) do
    room_id = Wtrmln.Room.get_room_id(message.seed)
    changeset(%Wtrmln.Message{}, Map.put(message, :room_id, room_id))
    |> Wtrmln.Repo.insert()
  end
end
