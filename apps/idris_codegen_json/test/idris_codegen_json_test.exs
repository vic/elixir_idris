defmodule Idris.Codegen.JSONTest do
  use ExUnit.Case
  doctest Idris.Codegen.JSON

  test "greets the world" do
    assert Idris.Codegen.JSON.hello() == :world
  end
end
