defmodule TodoHtmex.TodoHtmlPart do
  require EEx

  @template_dir File.cwd!() <> "/lib/todo_htmex/templates/"

  EEx.function_from_file(:def, :todo, @template_dir <> "todo/_todo.html.eex", [:todo])
end
