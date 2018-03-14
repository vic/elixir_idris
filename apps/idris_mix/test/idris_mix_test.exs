defmodule Idris.MixTest do
  use ExUnit.Case
  doctest Idris.Mix

  test "greets the world" do
    assert Idris.Mix.hello() == :world
  end
end
