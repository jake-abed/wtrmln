defmodule Wtrmln.Repo.Migrations.AddTimeout do
  use Ecto.Migration

  def change do
    alter table("rooms") do
      add :timeout, :integer
      add :last_used, :naive_datetime
    end
  end
end
