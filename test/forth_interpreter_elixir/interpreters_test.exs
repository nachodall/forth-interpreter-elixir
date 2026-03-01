defmodule ForthInterpreterElixir.InterpretersTest do
  use ForthInterpreterElixir.DataCase

  alias ForthInterpreterElixir.Interpreters

  describe "executions" do
    alias ForthInterpreterElixir.Interpreters.Execution

    import ForthInterpreterElixir.InterpretersFixtures

    @invalid_attrs %{input: nil, result: nil}

    test "list_executions/0 returns all executions" do
      execution = execution_fixture()
      assert Interpreters.list_executions() == [execution]
    end

    test "get_execution!/1 returns the execution with given id" do
      execution = execution_fixture()
      assert Interpreters.get_execution!(execution.id) == execution
    end

    test "create_execution/1 with valid data creates a execution" do
      valid_attrs = %{input: "some input", result: "some result"}

      assert {:ok, %Execution{} = execution} = Interpreters.create_execution(valid_attrs)
      assert execution.input == "some input"
      assert execution.result == "some result"
    end

    test "create_execution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interpreters.create_execution(@invalid_attrs)
    end

    test "update_execution/2 with valid data updates the execution" do
      execution = execution_fixture()
      update_attrs = %{input: "some updated input", result: "some updated result"}

      assert {:ok, %Execution{} = execution} =
               Interpreters.update_execution(execution, update_attrs)

      assert execution.input == "some updated input"
      assert execution.result == "some updated result"
    end

    test "update_execution/2 with invalid data returns error changeset" do
      execution = execution_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Interpreters.update_execution(execution, @invalid_attrs)

      assert execution == Interpreters.get_execution!(execution.id)
    end

    test "delete_execution/1 deletes the execution" do
      execution = execution_fixture()
      assert {:ok, %Execution{}} = Interpreters.delete_execution(execution)
      assert_raise Ecto.NoResultsError, fn -> Interpreters.get_execution!(execution.id) end
    end

    test "change_execution/1 returns a execution changeset" do
      execution = execution_fixture()
      assert %Ecto.Changeset{} = Interpreters.change_execution(execution)
    end
  end
end
