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

  @spec room_exists?(seed :: String.t()) :: boolean()
  def room_exists?(seed) do
    query = from r in Wtrmln.Room, where: r.seed == ^seed
    Wtrmln.Repo.exists?(query)
  end

  @spec get_room_id(seed :: String.t()) :: pos_integer()
  def get_room_id(seed) do
    query = from r in Wtrmln.Room, where: r.seed == ^seed, select: r.id
    Wtrmln.Repo.one!(query)
  end

  @spec create_room(seed :: String.t())
    :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_room(seed) do
    Wtrmln.Room.changeset(%Wtrmln.Room{}, %{seed: seed})
    |> Wtrmln.Repo.insert()
  end

  @spec delete_room(room_id :: pos_integer()) :: :ok | :error
  def delete_room(room_id) do
    query = from r in Wtrmln.Room, where: r.id == ^room_id
    {res, _} = Wtrmln.Repo.one!(query) |> Wtrmln.Repo.delete()
    res
  end
end
