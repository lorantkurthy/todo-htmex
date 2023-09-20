defmodule TodoHtmexTest do
  use ExUnit.Case
  doctest TodoHtmex

  test "greets the world" do
    assert TodoHtmex.hello() == :world
  end
end
