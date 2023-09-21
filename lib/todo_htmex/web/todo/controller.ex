defmodule TodoHtmex.Web.Todo.Controller do
  alias TodoHtmex.Todo.Server, as: TodoServer
  require Logger
  use Plug.Router

  alias TodoHtmex.Web.Todo.Html, as: TodoHtml
  alias TodoHtmex.Web.Todo.HtmlPart, as: TodoHtmlPart

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded]
  )

  plug(:dispatch)

  @title "Todos"

  # index
  get "/" do
    TodoServer.all_todos()
    |> TodoHtml.index(@title)
    |> then(&send_resp(conn, 200, &1))
  end

  # create
  post "/" do
    bparams = conn.body_params

    Logger.debug("create - #{inspect(bparams)}")

    note =
      bparams["note"]
      |> Plug.HTML.html_escape()

    TodoServer.all_todos()
    |> TodoServer.create_todo(%{note: note, id: nil})

    conn
    |> put_resp_header("location", "/todos/")
    |> send_resp(303, "")
  end

  # edit
  get "/:id/edit" do
    params = conn.params

    Logger.debug("edit - #{inspect(params)}")

    params["id"]
    |> String.to_integer()
    |> find_todo_by_id()
    |> TodoHtml.edit()
    |> then(&send_resp(conn, 200, &1))
  end

  # search
  get "/search" do
    qparams = conn.query_params

    Logger.debug("search - #{inspect(qparams)}")

    note =
      qparams["note"]
      |> Plug.HTML.html_escape()

    TodoServer.all_todos()
    |> TodoServer.search_todo(note)
    |> TodoHtml.search()
    |> then(&send_resp(conn, 200, &1))
  end

  # show
  get "/:id" do
    params = conn.params

    Logger.debug("show - #{inspect(params)}")

    params["id"]
    |> String.to_integer()
    |> find_todo_by_id()
    |> TodoHtmlPart.todo()
    |> then(&send_resp(conn, 200, &1))
  end

  # update
  patch "/:id" do
    params = conn.params
    bparams = conn.body_params

    Logger.debug("update - #{inspect(params)} - #{inspect(bparams)}")

    id =
      params["id"]
      |> String.to_integer()

    note =
      bparams["note"]
      |> Plug.HTML.html_escape()

    todo = %{id: id, note: note}

    TodoServer.all_todos() |> TodoServer.update_todo(todo)

    id
    |> find_todo_by_id()
    |> TodoHtmlPart.todo()
    |> then(&send_resp(conn, 200, &1))
  end

  # delete
  delete "/:id" do
    params = conn.params

    Logger.debug("delete - #{inspect(params)}")

    id =
      params["id"]
      |> String.to_integer()


    TodoServer.all_todos() |> TodoServer.delete_todo(id)

    conn
    |> send_resp(201, "")
  end

  # buld delete
  put "/completed" do
    bparams = conn.body_params

    Logger.debug("bulk delete - #{inspect(bparams)}")

    bparams["ids"]
    |> Enum.map(fn id ->
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
