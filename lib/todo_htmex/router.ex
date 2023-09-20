defmodule TodoHtmex.Router do
  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  plug(Plug.Logger)
  plug(Plug.Static, at: "/static/", from: {:todo_htmex, "priv/assets/"})
  plug(:match)
  plug(:dispatch)

  forward("/todos", to: TodoHtmex.TodoController)

  get "/health" do
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    Logger.error("kind: #{inspect(kind)}, reason: #{inspect(reason)}, stack: #{inspect(stack)}")
    send_resp(conn, conn.status, "")
  end
end
