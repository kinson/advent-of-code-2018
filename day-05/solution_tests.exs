ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case, async: true
  Code.require_file("solution.ex")

  test "solution returns resolved polymer length" do
    assert Solution.solve("test_input.txt") == 10
  end

  test "reactive pair returns true for J j" do
    assert Solution.reactive_pair('J', 'j') === true
  end
end
