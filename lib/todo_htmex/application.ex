defmodule TodoHtmex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:todo_htmex, :port)

    children = [
      {Bandit, scheme: :http, plug: TodoHtmex.Web.Router, port: port},
      {TodoHtmex.Todo.Server, nil}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodoHtmex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
