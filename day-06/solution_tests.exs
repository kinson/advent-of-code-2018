ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case, async: true
  Code.require_file("solution.ex")

  test "the truth" do
    assert 1 + 1 == 2
  end
end
