defmodule TodoHtmex.TodoController do
  alias TodoHtmex.TodoServer
  require Logger
  use Plug.Router

  alias TodoHtmex.TodoHtml
  alias TodoHtmex.TodoHtmlPart

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded]
  )

  plug(:dispatch)

  # index
  get "/" do
    title = "Todos"

    TodoServer.all_todos()
    |> TodoHtml.index(title)
    |> then(&send_resp(conn, 200, &1))
  end

  # create
  post "/" do
    bparams = conn.body_params
    note = Map.get(bparams, "note")

    Logger.debug("create: #{inspect(bparams)}")

    TodoServer.all_todos()
    |> TodoServer.create_todo(%{note: note, id: nil})

    conn
    |> put_resp_header("location", "/todos/")
    |> send_resp(303, "")
  end

  # edit
  get "/:id/edit" do
    params = conn.params
    id = String.to_integer(params["id"])

    find_todo_by_id(id)
    |> TodoHtml.edit()
    |> then(&send_resp(conn, 200, &1))
  end

  get "/search" do
    qparams = conn.query_params
    note = qparams["note"]
    Logger.debug("search: #{inspect(qparams)}")

    TodoServer.all_todos()
    |> TodoServer.search_todo(note)
    |> TodoHtml.search()
    |> then(&send_resp(conn, 200, &1))
  end

  # show
  get "/:id" do
    params = conn.params
    id = String.to_integer(params["id"])

    find_todo_by_id(id)
    |> TodoHtmlPart.todo()
    |> then(&send_resp(conn, 200, &1))
  end

  # update
  patch "/:id" do
    params = conn.params
    bparams = conn.body_params
    id = String.to_integer(params["id"])
    note = bparams["note"]
    todo = %{id: id, note: note}
    Logger.info(note)
    TodoServer.all_todos() |> TodoServer.update_todo(todo)

    find_todo_by_id(id)
    |> TodoHtmlPart.todo()
    |> then(&send_resp(conn, 200, &1))
  end

  # delete
  delete "/:id" do
    params = conn.params
    id = String.to_integer(params["id"])
    TodoServer.all_todos() |> TodoServer.delete_todo(id)

    conn
    |> send_resp(201, "")
  end

  # buld delete
  put "/completed" do
    bparams = conn.body_params
    ids = bparams["ids"]

    Enum.map(ids, fn id ->
      id = String.to_integer(id)
      TodoServer.all_todos() |> TodoServer.delete_todo(id)
    end)

    TodoServer.all_todos()
    |> TodoHtml.search()
    |> then(&send_resp(conn, 200, &1))
  end

  defp find_todo_by_id(id) do
    TodoServer.all_todos()
    |> TodoServer.get_todo(id)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
