ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case, async: true
  Code.require_file("solution.ex")

  test "solution should return elf id 10 multiplied by the minute 24" do
    assert Solution.solve("test_input.txt") == 10 * 24
  end

  test "bonus should return elf id multiplied by number of minutes asleep" do
    assert Solution.bonus("test_input.txt") == 45 * 99
  end
end
