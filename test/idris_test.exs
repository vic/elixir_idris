defmodule IdrisTest do
  use ExUnit.Case
  doctest Idris

  test "greets the world" do
    assert Idris.hello() == :world
  end
end
