defmodule Wtrmln.Room do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "rooms" do
    field :seed, :string
    field :timeout, :integer
    field :last_used, :naive_datetime
    has_many :messages, Wtrmln.Message

    timestamps(type: :naive_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> IO.inspect()
    |> cast(attrs, [:seed, :timeout])
    |> validate_required([:seed, :timeout])
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

  @spec get_room_info(seed :: String.t()) :: {pos_integer(), non_neg_integer()}
  def get_room_info(seed) do
    query =
      from r in Wtrmln.Room,
      where: r.seed == ^seed,
      select: {r.id, r.timeout}
    Wtrmln.Repo.one!(query)
  end

  @spec create_room(seed :: String.t(), timeout :: non_neg_integer())
    :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_room(seed, timeout \\ 0) do
    Wtrmln.Room.changeset(%Wtrmln.Room{}, %{seed: seed, timeout: timeout})
    |> Wtrmln.Repo.insert()
  end

  @spec delete_room(room_id :: pos_integer()) :: :ok | :error
  def delete_room(room_id) do
    query = from r in Wtrmln.Room, where: r.id == ^room_id
    {res, _} = Wtrmln.Repo.one!(query) |> Wtrmln.Repo.delete()
    res
  end
end
