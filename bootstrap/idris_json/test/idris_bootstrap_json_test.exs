defmodule IdrisBootstrap.JsonTest do
  use ExUnit.Case
  doctest IdrisBootstrap.Json

  test "greets the world" do
    assert IdrisBootstrap.Json.hello() == :world
  end
end
