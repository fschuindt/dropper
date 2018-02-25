defmodule DropperTest do
  use ExUnit.Case
  doctest Dropper

  test "greets the world" do
    assert Dropper.hello() == :world
  end
end
