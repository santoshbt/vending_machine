defmodule VendingMachine.VendingMachineSupervisor do
  @doc ~S"""
    The supervisor in support with test suite.
    This facilitates for percistance of pid across multiple test blocks
  """

  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: :test)
  end

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Supervisor.init([VendingMachine], strategy: :simple_one_for_one)
  end
end
