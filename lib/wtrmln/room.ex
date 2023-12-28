defmodule Wtrmln.Room do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "rooms" do
    field :seed, :string
    has_many :messages, Wtrmln.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:seed])
    |> validate_required([:seed])
  end

  def room_exists?(seed) do
    query = from r in Wtrmln.Room, where: r.seed == ^seed
    Wtrmln.Repo.exists?(query)
  end

  def get_room_id(seed) do
    query = from r in Wtrmln.Room, where: r.seed == ^seed, select: r.id
    Wtrmln.Repo.one!(query)
  end

  def create_room(seed) do
    Wtrmln.Room.changeset(%Wtrmln.Room{}, %{seed: seed})
    |> Wtrmln.Repo.insert()
  end
end
