defmodule TodoHtmex.TodoHtml do
  require EEx
  require Logger

  @template_dir File.cwd!() <> "/lib/todo_htmex/templates/"

  EEx.function_from_file(:def, :root_html, @template_dir <> "root.html.eex", [
    :inner_content,
    :title
  ])

  EEx.function_from_file(:def, :edit, @template_dir <> "todo/edit.html.eex", [:todo])
  EEx.function_from_file(:def, :index_html, @template_dir <> "todo/index.html.eex", [:todos])
  EEx.function_from_file(:def, :search, @template_dir <> "todo/search.html.eex", [:todos])

  def index(todos, title) do
    inner_content = index_html(todos)
    root_html(inner_content, title)
  end
end
