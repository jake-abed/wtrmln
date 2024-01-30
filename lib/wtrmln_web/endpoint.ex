defmodule WtrmlnWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :wtrmln

  @decay true

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_wtrmln_key",
    signing_salt: "dxhED9nw",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :wtrmln,
    gzip: false,
    only: WtrmlnWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :wtrmln
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug :update_decay_flag
  plug WtrmlnWeb.Router
  
  def update_decay_flag(conn, _opts) do
    {status, new_conn} = set_flag_cookie(conn, "decay", Atom.to_string(@decay))
    if status === :update do
      cond do
        @decay -> FunWithFlags.enable(:decay)
        true -> FunWithFlags.disable(:decay)
      end
    end
    IO.inspect(FunWithFlags.enabled?(:decay))
    new_conn
  end


  defp set_flag_cookie(conn, flag, flag_state) do
    decay_cookie = fetch_cookies(conn).cookies |> Map.get(flag)
    cond do
      decay_cookie == nil ->
        {:update, put_resp_cookie(conn, flag, flag_state)}
      decay_cookie !== flag_state ->
        {:update, put_resp_cookie(conn, flag, flag_state)}
      decay_cookie == "false" ->
        {:update, conn}
      true -> {:ok, conn}
    end
  end
end
