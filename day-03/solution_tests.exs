ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case, async: true
  Code.require_file("solution.ex")

  test "returns correct overlap" do
    assert Solution.solve("test_input.txt") == 4
  end

  test "returns correct patch without overlaps" do
    assert Solution.bonus("test_input.txt") == 3
  end
end
