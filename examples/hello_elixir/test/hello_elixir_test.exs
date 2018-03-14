defmodule HelloElixirTest do
  use ExUnit.Case
  doctest HelloElixir

  test "greets the world" do
    assert HelloElixir.hello() == :world
  end
end
