defmodule HelloIdrisTest do
  use ExUnit.Case
  doctest HelloIdris

  test "greets the world" do
    assert HelloIdris.hello() == :world
  end
end
