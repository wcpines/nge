# test/nge/importer_test.exs
defmodule Nge.ImporterTest do
  use ExUnit.Case, async: true
  alias Nge.Importer

  @invalid_file "not_real_file"
  @name :testing_importer_genserver

  setup do
    importer_pid = start_supervised!(Importer)

    %{importer: importer_pid}
  end

  describe "run/2" do
    test "it returns an error with an invalid CSV", %{importer: importer_pid} do
      {:error, msg} = Importer.run(importer_pid, "some_auth_code", @invalid_file)
      assert String.match?(msg, ~r/does not reference a valid CSV/)
    end

    test "unknown ", %{importer: importer_pid} do
      Importer.run(importer_pid, "some_auth_code")
    end
  end
end
