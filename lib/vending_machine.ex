defmodule VendingMachine do
  alias Amount
  alias Display

  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient, type: :worker

  @doc ~S"""
    The vending machine is controlled by Genserver and process communication.
    Based on the status of the list the transations of loading and consumption takes place.
  """

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  @spec add(atom | pid | {atom, any} | {:via, atom, any}, any, any) :: :ok
  def add(pid, item, price) do
    GenServer.cast(pid, %{item: item, price: price})
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  def select_item(pid, item, inserted_coin) do
    GenServer.call(pid, {:select, item, inserted_coin})
  end

  def handle_call(:view, _from, list) do
    {:reply, list, list}
  end

  def handle_call({:select, item, inserted_coin}, _from, list) do
    selected_item = %{item: item, inserted_coin: inserted_coin}
    {updated_list, message} = if length(list) > 0 do
      {change, amount, list} = Amount.calculate_change(selected_item, list)
      Amount.convert_pence_to_pound(amount)

      {updated_list, message} = Display.message(change, list, amount)
      updated_list = remove_item_from_machine(change, selected_item, updated_list)
      if length(updated_list) > 0, do: updated_list,
                                  else: []

      {updated_list, message}
    else
      Display.message("no_items", [], 0)
    end

    {:reply, message, updated_list}
  end

  def handle_cast(%{item: item, price: price_in_pence}, list) do
    updated_list = [%{item: item, price: price_in_pence} | list]
    {:noreply, updated_list}
  end

  defp remove_item_from_machine(change, selected_item, updated_list) do
    if Enum.member?(["change_required", "no_change_required"], change) do
      Enum.reject(updated_list,
                    fn(item_map) -> item_map.item == selected_item.item
                            && Amount.get_value_in_pence(item_map.price) <= Amount.get_value_in_pence(selected_item.inserted_coin)
                      end )
    else
      updated_list
    end
  end

  def init(list) do
    {:ok, list}
  end
end
