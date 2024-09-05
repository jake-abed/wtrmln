defmodule Wtrmln.Timeout do
  use GenServer

  # Client
  def start_link({seed, minutes}) do
    timeout_seed = String.to_atom(seed <> "-timeout")
    GenServer.start_link(__MODULE__, {seed, minutes}, name: timeout_seed)
  end

  # Timeout should always be passed in as a minutes value.
  def join(pid) do
    GenServer.cast(pid, :join)
  end

  def message(pid) do
    GenServer.cast(pid, :message)
  end

  # Server callbacks

  @impl true
  @spec init({String.t(), integer()}) :: {:ok, {String.t(), integer()}, timeout()}
  def init({seed, minutes}) do
    {:ok, {seed, minutes}, minutes * 60000}
  end

  @impl true
  def handle_cast(:join, {seed, minutes}) do
    {:noreply, {seed, minutes}, minutes * 60000}
  end

  @impl true
  def handle_cast(:message, {seed, minutes}) do
    {:noreply, {seed, minutes}, minutes * 60000}
  end

  @impl true
  def handle_info(:timeout, {seed, minutes}) do
    WtrmlnWeb.Endpoint.broadcast(seed, "spit", %{seed: seed, username: "TIMEOUT"})
    {:noreply, {seed, minutes}}
  end

end
