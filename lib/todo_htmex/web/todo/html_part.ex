defmodule TodoHtmex.Web.Todo.HtmlPart do
  require EEx

  @template_dir File.cwd!() <> "/lib/todo_htmex/web/templates/"

  EEx.function_from_file(:def, :todo, @template_dir <> "todo/_todo.html.eex", [:todo])
end
